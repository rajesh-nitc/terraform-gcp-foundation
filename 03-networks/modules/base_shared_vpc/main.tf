locals {
  mode                                  = var.mode == null ? "" : var.mode == "hub" ? "-hub" : "-spoke"
  vpc_name                              = "${var.environment_code}-shared-base${local.mode}"
  network_name                          = "vpc-${local.vpc_name}"
  private_googleapis_cidr               = data.google_netblock_ip_ranges.private-googleapis.cidr_blocks_ipv4[0]
  private_googleapis_cidr_hosts_list    = [for i in range(4) : cidrhost(local.private_googleapis_cidr, i)]
  restricted_googleapis_cidr            = data.google_netblock_ip_ranges.restricted-googleapis.cidr_blocks_ipv4[0]
  restricted_googleapis_cidr_hosts_list = [for i in range(4) : cidrhost(local.restricted_googleapis_cidr, i)]
}

/******************************************
  Base Network Hub
*****************************************/

data "google_projects" "base_net_hub" {
  count  = var.mode == "spoke" ? 1 : 0
  filter = "parent.id:${split("/", data.google_active_folder.common.name)[1]} labels.application_name=org-base-net-hub lifecycleState=ACTIVE"
}

data "google_compute_network" "vpc_base_net_hub" {
  count   = var.mode == "spoke" ? 1 : 0
  name    = "vpc-c-shared-base-hub"
  project = data.google_projects.base_net_hub[0].projects[0].project_id
}

/******************************************
  Shared VPC configuration
 *****************************************/

module "main" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "~> 5.1"
  project_id                             = var.project_id
  network_name                           = local.network_name
  shared_vpc_host                        = true
  delete_default_internet_gateway_routes = true
  routing_mode                           = "REGIONAL"

  subnets          = var.subnets
  secondary_ranges = var.secondary_ranges

  routes = concat(
    [{
      name              = "rt-${local.vpc_name}-1000-all-default-private-api"
      description       = "Route through IGW to allow private google api access."
      destination_range = local.private_googleapis_cidr
      next_hop_internet = true
      priority          = "1000"
    }],
    var.nat_enabled ?
    [
      {
        name              = "rt-${local.vpc_name}-1000-egress-internet-default"
        description       = "Tag based route through IGW to access internet"
        destination_range = "0.0.0.0/0"
        tags              = "egress-internet"
        next_hop_internet = true
        priority          = "1000"
      }
    ]
    : [],
    var.windows_activation_enabled ?
    [{
      name              = "rt-${local.vpc_name}-1000-all-default-windows-kms"
      description       = "Route through IGW to allow Windows KMS activation for GCP."
      destination_range = "35.190.247.13/32"
      next_hop_internet = true
      priority          = "1000"
      }
    ]
    : []
  )
}

/***************************************************************
  VPC Peering Configuration
 **************************************************************/

module "peering" {
  source                    = "terraform-google-modules/network/google//modules/network-peering"
  version                   = "~> 4.1"
  count                     = var.mode == "spoke" ? 1 : 0
  prefix                    = "np"
  local_network             = module.main.network_self_link
  peer_network              = data.google_compute_network.vpc_base_net_hub[0].self_link
  export_peer_custom_routes = true
}

/***************************************************************
  Configure Service Networking for Cloud SQL & future services.
 **************************************************************/

resource "google_compute_global_address" "private_service_access_address" {
  count         = var.private_service_cidr != null ? 1 : 0
  name          = "ga-${local.vpc_name}-vpc-peering-internal"
  project       = var.project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = element(split("/", var.private_service_cidr), 0)
  prefix_length = element(split("/", var.private_service_cidr), 1)
  network       = module.main.network_self_link

  depends_on = [module.peering]
}

resource "google_service_networking_connection" "private_vpc_connection" {
  count                   = var.private_service_cidr != null ? 1 : 0
  network                 = module.main.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_access_address[0].name]

  depends_on = [module.peering]
}

resource "google_compute_network_peering_routes_config" "peering_config" {
  count                = var.mode == "spoke" ? 1 : 0
  project              = var.project_id
  peering              = "servicenetworking-googleapis-com"
  network              = module.main.network_name
  import_custom_routes = true
  export_custom_routes = true
  depends_on           = [google_service_networking_connection.private_vpc_connection]
}

/***************************************************************
  DNS Peering with managed services like Apigeex
 **************************************************************/

resource "google_service_networking_peered_dns_domain" "example" {
  count      = var.mode == "spoke" && var.enable_private_service_dns_peering ? 1 : 0
  project    = var.project_id
  name       = "${replace(var.domain, ".", "-")}peering"
  network    = module.main.network_name
  dns_suffix = var.domain
  depends_on = [google_service_networking_connection.private_vpc_connection]
}