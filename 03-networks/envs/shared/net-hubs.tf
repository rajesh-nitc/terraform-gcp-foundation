/******************************************
  Base Network Hub Project
*****************************************/

data "google_projects" "base_net_hub" {
  count  = var.enable_hub_and_spoke ? 1 : 0
  filter = "parent.id:${split("/", data.google_active_folder.common.name)[1]} labels.application_name=org-base-net-hub lifecycleState=ACTIVE"
}

/******************************************
  Base Network Hub VPC
*****************************************/

module "base_shared_vpc" {
  source                        = "../../modules/base_shared_vpc"
  count                         = var.enable_hub_and_spoke ? 1 : 0
  project_id                    = local.base_net_hub_project_id
  environment_code              = local.environment_code
  org_id                        = var.org_id
  parent_folder                 = var.parent_folder
  default_region1               = var.default_region1
  default_region2               = var.default_region2
  domain                        = var.domain
  dns_enable_inbound_forwarding = var.base_hub_dns_enable_inbound_forwarding
  dns_enable_logging            = var.base_hub_dns_enable_logging
  firewall_enable_logging       = var.base_hub_firewall_enable_logging
  optional_fw_rules_enabled     = true
  windows_activation_enabled    = true # Fw rule for windows vms
  nat_enabled                   = var.base_hub_nat_enabled
  nat_bgp_asn                   = var.base_hub_nat_bgp_asn
  nat_num_addresses_region1     = var.base_hub_nat_num_addresses_region1
  folder_prefix                 = var.folder_prefix
  mode                          = "hub"

  subnets = [
    {
      subnet_name           = "sb-c-shared-base-hub-${var.default_region1}"
      subnet_ip             = local.base_subnet_primary_ranges[var.default_region1]
      subnet_region         = var.default_region1
      subnet_private_access = true
      subnet_flow_logs      = var.subnetworks_enable_logging
      description           = "Base network hub subnet for ${var.default_region1}"
    },
    {
      subnet_name           = "sb-c-shared-base-hub-${var.default_region2}"
      subnet_ip             = local.base_subnet_primary_ranges[var.default_region2]
      subnet_region         = var.default_region2
      subnet_private_access = true
      subnet_flow_logs      = var.subnetworks_enable_logging
      description           = "Base network hub subnet for ${var.default_region2}"
    }
  ]
  secondary_ranges = {}

  # DNS on demand
  enable_dns_zone_private_googleapis = var.enable_dns_zone_private_googleapis
  enable_dns_peering                 = var.enable_dns_peering

  allow_all_ingress_ranges = var.allow_all_ingress_ranges
  allow_all_egress_ranges  = var.allow_all_egress_ranges

  depends_on = [module.dns_hub_vpc]
}
