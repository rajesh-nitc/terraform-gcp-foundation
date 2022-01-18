locals {
  private_googleapis_cidr               = data.google_netblock_ip_ranges.private-googleapis.cidr_blocks_ipv4[0]
  private_googleapis_cidr_hosts_list    = [for i in range(4) : cidrhost(local.private_googleapis_cidr, i)]
  restricted_googleapis_cidr            = data.google_netblock_ip_ranges.restricted-googleapis.cidr_blocks_ipv4[0]
  restricted_googleapis_cidr_hosts_list = [for i in range(4) : cidrhost(local.restricted_googleapis_cidr, i)]
  dns_forwarders_cidr                   = data.google_netblock_ip_ranges.dns-forwarders.cidr_blocks_ipv4[0]
}

module "main" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "~> 4.0"
  project_id                             = var.project_id
  network_name                           = "vpc-onprem"
  shared_vpc_host                        = false
  delete_default_internet_gateway_routes = true
  routing_mode                           = "REGIONAL"

  subnets = [
    {
      subnet_name           = "sb-onprem-${var.default_region1}"
      subnet_ip             = "10.2.0.0/24"
      subnet_region         = var.default_region1
      subnet_private_access = false
      subnet_flow_logs      = false
      description           = "First onprem subnet example."
    },
  ]
}