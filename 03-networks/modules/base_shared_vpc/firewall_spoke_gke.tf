module "gke_fw_rules" {
  source                  = "../firewall_gke"
  for_each                = var.gke_fw_rules
  environment_code        = var.environment_code
  network_project_id      = var.project_id
  network                 = module.main.network_name
  cluster_short_name      = each.key
  cluster_network_tag     = each.value.network_tag
  master_ipv4_cidr_block  = each.value.master_ipv4_cidr_block
  cluster_subnet_cidr     = each.value.subnet_cidr
  ip_range_pods           = each.value.ip_range_pods
  webhooks_inbound_ports  = ["8443", "9443", "15017"]
  firewall_enable_logging = var.firewall_enable_logging
}