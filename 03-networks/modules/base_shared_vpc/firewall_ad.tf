resource "google_compute_firewall" "allow_e_to_ad" {
  count     = var.enable_ad_fw_rule ? 1 : 0
  name      = "fw-${var.environment_code}-shared-base-allow-e-ad"
  network   = module.main.network_name
  project   = var.project_id
  direction = "EGRESS"
  priority  = 1000

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  allow {
    protocol = "all"
  }

  destination_ranges = var.ad_domain_ip_range
  target_tags        = ["allow-egress-to-ad"]
}