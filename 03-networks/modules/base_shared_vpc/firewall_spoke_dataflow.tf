resource "google_compute_firewall" "allow_dataflow_internal" {
  count     = var.enable_dataflow_fw_rule ? 1 : 0
  name      = "fw-${var.environment_code}-shared-base-1000-i-a-dataflow-internal"
  network   = module.main.network_name
  project   = var.project_id
  direction = "INGRESS"
  priority  = 65534

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  allow {
    protocol = "tcp"
    ports    = ["12345", "12346"]
  }

  source_tags = ["dataflow"]
  target_tags = ["dataflow"]
}

resource "google_compute_firewall" "allow_dataflow_internal_egress" {
  count     = var.enable_dataflow_fw_rule ? 1 : 0
  name      = "fw-${var.environment_code}-shared-base-1000-e-a-dataflow-internal"
  network   = module.main.network_name
  project   = var.project_id
  direction = "EGRESS"
  priority  = 65534

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  allow {
    protocol = "tcp"
    ports    = ["12345", "12346"]
  }

  target_tags = ["dataflow"]
}