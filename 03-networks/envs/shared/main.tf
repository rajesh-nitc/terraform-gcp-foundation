locals {
  parent_id        = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
  env              = "common"
  environment_code = "c"

  # dns
  dns_hub_project_id      = data.google_projects.dns_hub.projects[0].project_id
  private_googleapis_cidr = data.google_netblock_ip_ranges.private-googleapis.cidr_blocks_ipv4[0]
  dns_forwarders_cidr     = data.google_netblock_ip_ranges.dns-forwarders.cidr_blocks_ipv4[0]

  # net
  base_net_hub_project_id = try(data.google_projects.base_net_hub[0].projects[0].project_id, null)

  base_subnet_primary_ranges = {
    (var.default_region1) = "10.0.0.0/24"
    (var.default_region2) = "10.1.0.0/24"
  }

}