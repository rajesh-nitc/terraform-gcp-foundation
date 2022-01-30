locals {
  environment_code = "d"
  env              = "development"
  base_project_id  = data.google_projects.base_host_project.projects[0].project_id
  parent_id        = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
  mode             = var.enable_hub_and_spoke ? "spoke" : null

  # Subnets
  team_subnets = flatten([for i in var.subnets : {

    subnet_name           = "sb-${local.environment_code}-shared-base-${i.region}-${i.team}"
    subnet_ip             = i.subnet_ip
    subnet_region         = i.region
    subnet_private_access = true
    subnet_flow_logs      = false
    } if !can(regex("REGIONAL_MANAGED_PROXY", i.purpose))
    ]
  )

  proxy_only_subnets = flatten([for i in var.subnets : {

    subnet_name           = "sb-${local.environment_code}-shared-base-${i.region}-${i.team}"
    subnet_ip             = i.subnet_ip
    subnet_region         = i.region
    subnet_private_access = false
    subnet_flow_logs      = false
    purpose               = i.purpose
    role                  = i.role
    } if can(regex("REGIONAL_MANAGED_PROXY", i.purpose))
    ]
  )

  subnets = concat(local.team_subnets, local.proxy_only_subnets)

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

  # Proxy only
  proxy_only_subnet_ranges = [for i in var.subnets : i.subnet_ip if i.team == "proxy-only"]
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
  dns_enable_inbound_forwarding = var.dns_enable_inbound_forwarding
  dns_enable_logging            = var.dns_enable_logging
  firewall_enable_logging       = var.firewall_enable_logging
  nat_enabled                   = var.nat_enabled
  nat_bgp_asn                   = var.nat_bgp_asn
  nat_num_addresses_region1     = var.nat_num_addresses_region1
  folder_prefix                 = var.folder_prefix
  mode                          = local.mode

  subnets          = local.subnets
  secondary_ranges = local.secondary_ranges

  # DNS on demand
  enable_dns_zone_private_googleapis = var.enable_dns_zone_private_googleapis
  enable_dns_peering                 = var.enable_dns_peering
  enable_dns_zone_gcr                = var.enable_dns_zone_gcr # dataflow pull images from gcr.io
  enable_dns_zone_pkg_dev            = var.enable_dns_zone_pkg_dev

  # Enable all fw rules, they don't cost unless firewall insights api is enabled
  enable_gke_fw_rules        = true
  enable_dataflow_fw_rule    = true
  windows_activation_enabled = true
  enable_ad_fw_rule          = true
  enable_proxy_only_fw_rule  = true

  # Fw
  cluster_network_tag        = var.budita_cluster_uscentral1_cluster_network_tag
  cluster_endpoint_for_nodes = var.budita_cluster_uscentral1_cluster_endpoint_for_nodes
  cluster_subnet_cidr        = local.budita_cluster_uscentral1_subnet_cidr[0]
  cluster_ip_range_pods      = local.budita_cluster_uscentral1_cluster_ip_range_pods[0]
  ad_domain_ip_range         = local.ad_domain_ip_range
  proxy_only_subnet_ranges   = local.proxy_only_subnet_ranges
  allow_all_ingress_ranges   = var.allow_all_ingress_ranges
  allow_all_egress_ranges    = var.allow_all_egress_ranges

}
