module budita_cluster_uscentral1_fw_rules {
  source                     = "../gke_firewall_rules"
  count                      = var.gke_fw_rules_enabled ? 1 : 0
  environment_code           = var.environment_code
  network_project_id         = var.project_id
  network                    = module.main.network_name
  cluster_network_tag        = var.budita_cluster_uscentral1_cluster_network_tag
  cluster_endpoint_for_nodes = var.budita_cluster_uscentral1_cluster_endpoint_for_nodes
  cluster_subnet_cidr        = var.budita_cluster_uscentral1_cluster_subnet_cidr
  ip_range_pods              = var.budita_cluster_uscentral1_cluster_ip_range_pods
  webhooks_inbound_ports     = ["8443", "9443", "15017"]
  firewall_enable_logging    = var.firewall_enable_logging
}