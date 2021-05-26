locals {
  environment_code    = "d"
  env                 = "development"
  base_project_id     = data.google_projects.base_host_project.projects[0].project_id
  parent_id           = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
  mode                = var.enable_hub_and_spoke ? "spoke" : null
  bgp_asn_number      = var.enable_partner_interconnect ? "16550" : "64514"
  enable_transitivity = var.enable_hub_and_spoke && var.enable_hub_and_spoke_transitivity

  base_subnet_aggregates = ["10.0.0.0/16", "10.1.0.0/16", "100.64.0.0/16", "100.65.0.0/16"]
  base_hub_subnet_ranges = ["10.0.0.0/24", "10.1.0.0/24"]

  # Base Shared VPC

  base_private_service_cidr = "10.16.64.0/21"

  base_subnet_primary_ranges = flatten([for k, v in var.subnets : [for subnet in v : {

    subnet_name           = "sb-${local.environment_code}-shared-base-${k}-${subnet.team}"
    subnet_ip             = subnet.subnet_ip
    subnet_region         = k
    subnet_private_access = subnet.enable_private_access
    subnet_flow_logs      = subnet.enable_flow_logs
    }
  ]])

  # This is manual
  subnet_secondary_ranges = {
    (var.default_region1) = [
      {
        range_name    = "rn-${local.environment_code}-shared-base-${var.default_region1}-gke-pod"
        ip_cidr_range = "100.64.64.0/21"
      },
      {
        range_name    = "rn-${local.environment_code}-shared-base-${var.default_region1}-gke-svc"
        ip_cidr_range = "100.64.72.0/21"
      }
    ]
  }

  # This is manual
  gke_subnet_secondary_ranges = {
    "sb-${local.environment_code}-shared-base-${var.default_region1}-gke" = local.subnet_secondary_ranges[var.default_region1]
  }


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
  private_service_cidr          = local.base_private_service_cidr
  org_id                        = var.org_id
  parent_folder                 = var.parent_folder
  default_region1               = var.default_region1
  default_region2               = var.default_region2
  domain                        = var.domain
  bgp_asn_subnet                = local.bgp_asn_number
  windows_activation_enabled    = var.windows_activation_enabled
  dns_enable_inbound_forwarding = var.dns_enable_inbound_forwarding
  dns_enable_logging            = var.dns_enable_logging
  firewall_enable_logging       = var.firewall_enable_logging
  optional_fw_rules_enabled     = true
  nat_enabled                   = var.nat_enabled
  nat_bgp_asn                   = var.nat_bgp_asn
  nat_num_addresses_region1     = var.nat_num_addresses_region1
  nat_num_addresses_region2     = var.nat_num_addresses_region2
  nat_num_addresses             = var.nat_num_addresses
  folder_prefix                 = var.folder_prefix
  mode                          = local.mode

  subnets          = local.base_subnet_primary_ranges
  secondary_ranges = local.gke_subnet_secondary_ranges

  allow_all_ingress_ranges = local.enable_transitivity ? local.base_hub_subnet_ranges : null
  allow_all_egress_ranges  = local.enable_transitivity ? local.base_subnet_aggregates : null

}
