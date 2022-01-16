resource "google_compute_firewall" "allow_egress" {
  name      = "fw-onprem-e-a"
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

  destination_ranges = [
    local.private_googleapis_cidr,
    local.dns_forwarders_cidr,
    var.gcp_default_region1_dev_range,
  ]
}

resource "google_compute_firewall" "allow_ingress" {
  name      = "fw-onprem-1000-i-a"
  network   = module.main.network_name
  project   = var.project_id
  direction = "INGRESS"
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

  source_ranges = [
    local.private_googleapis_cidr,
    local.dns_forwarders_cidr,
    var.gcp_default_region1_dev_range,
  ]
}

resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "fw-onprem-1000-i-a-all-allow-iap-ssh-tcp-22"
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

  source_ranges = concat(data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4)

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["allow-iap-ssh"]
}