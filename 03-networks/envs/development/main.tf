locals {
  environment_code       = "d"
  env                    = "development"
  base_project_id        = data.google_projects.base_host_project.projects[0].project_id
  parent_id              = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
  mode                   = var.enable_hub_and_spoke ? "spoke" : null
  bgp_asn_number         = var.enable_partner_interconnect ? "16550" : "64514"
  enable_transitivity    = var.enable_hub_and_spoke && var.enable_hub_and_spoke_transitivity
  base_subnet_aggregates = []
  base_hub_subnet_ranges = []

  # Subnets
  base_subnet_primary_ranges = flatten([for i in var.subnets : {

    subnet_name           = "sb-${local.environment_code}-shared-base-${i.region}-${i.team}"
    subnet_ip             = i.subnet_ip
    subnet_region         = i.region
    subnet_private_access = i.enable_private_access
    subnet_flow_logs      = i.enable_flow_logs
    }
    ]
  )

  # GKE
  secondary_ranges = { for i in var.subnets :

    "sb-${local.environment_code}-shared-base-${i.region}-${i.team}" => [for k, v in i.secondary_ip_range : {
      range_name    = "rn-${local.environment_code}-shared-base-${i.region}-gke-${k}"
      ip_cidr_range = v
      }
    ]
  }

  budita_cluster_uscentral1_subnet_cidr           = [for i in var.subnets : i.subnet_ip if i.team == "gke" && i.region == var.default_region1]
  budita_cluster_uscentral1_cluster_ip_range_pods = [for i in var.subnets : i.secondary_ip_range["pod"] if i.team == "gke" && i.region == var.default_region1]

  # AD
  ad_domain_ip_range = [for i in var.subnets : i.subnet_ip if i.team == "ad" && i.region == var.default_region1]
}

data "google_active_folder" "env" {
  display_name = "${var.folder_prefix}-${local.env}"
  parent       = local.parent_id
}

data "google_projects" "base_host_project" {
  filter = "parent.id:${split("/", data.google_active_folder.env.name)[1]} labels.application_name=base-shared-vpc-host labels.environment=${local.env} lifecycleState=ACTIVE"
}

module "base_shared_vpc" {
  source                        = "../../modules/base_shared_vpc"
  project_id                    = local.base_project_id
  environment_code              = local.environment_code
  private_service_cidr          = var.private_service_cidr
  org_id                        = var.org_id
  parent_folder                 = var.parent_folder
  default_region1               = var.default_region1
  default_region2               = var.default_region2
  domain                        = var.domain
  bgp_asn_subnet                = local.bgp_asn_number
  dns_enable_inbound_forwarding = var.dns_enable_inbound_forwarding
  dns_enable_logging            = var.dns_enable_logging
  firewall_enable_logging       = var.firewall_enable_logging
  optional_fw_rules_enabled     = true
  windows_activation_enabled    = true # Fw rule for windows vms
  nat_enabled                   = var.nat_enabled
  nat_bgp_asn                   = var.nat_bgp_asn
  nat_num_addresses_region1     = var.nat_num_addresses_region1
  nat_num_addresses_region2     = var.nat_num_addresses_region2
  nat_num_addresses             = var.nat_num_addresses
  folder_prefix                 = var.folder_prefix
  mode                          = local.mode

  subnets          = local.base_subnet_primary_ranges
  secondary_ranges = local.secondary_ranges

  allow_all_ingress_ranges = local.enable_transitivity ? local.base_hub_subnet_ranges : null
  allow_all_egress_ranges  = local.enable_transitivity ? local.base_subnet_aggregates : null

  # Dataflow
  enable_dataflow_fw_rule = true

  # GKE firewall rules for single budita cluster in us-central1
  enable_gke_fw_rules        = true
  cluster_network_tag        = var.budita_cluster_uscentral1_cluster_network_tag
  cluster_endpoint_for_nodes = var.budita_cluster_uscentral1_cluster_endpoint_for_nodes
  cluster_subnet_cidr        = local.budita_cluster_uscentral1_subnet_cidr[0]
  cluster_ip_range_pods      = local.budita_cluster_uscentral1_cluster_ip_range_pods[0]

  # Destroy dns zones when not in use to save cost
  create_spoke_dns_zones = var.create_spoke_dns_zones

  # AD
  enable_ad_fw_rule  = true
  ad_domain_ip_range = local.ad_domain_ip_range

}
