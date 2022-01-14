resource "google_compute_firewall" "allow_proxy_only" {
  count   = var.enable_proxy_only_fw_rule ? 1 : 0
  name    = "fw-${var.environment_code}-shared-base-1000-i-a-all-allow-proxy-only-tcp-22"
  network = module.main.network_name
  project = var.project_id

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  source_ranges = var.proxy_only_subnet_ranges

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080"]
  }

  target_tags = ["allow-proxy-only"]
}