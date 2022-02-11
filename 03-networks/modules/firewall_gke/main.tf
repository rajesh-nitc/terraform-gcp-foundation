/******************************************
  Match the gke-<CLUSTER>-<ID>-all INGRESS
  firewall rule created by GKE but for EGRESS
  Required for clusters when VPCs enforce
  a default-deny egress rule
 *****************************************/

resource "google_compute_firewall" "intra_egress" {
  name        = "fw-${var.environment_code}-${var.cluster_short_name}-e-a-gke-intra-cluster-egress"
  description = "Managed by terraform gke module: Allow pods to communicate with each other and the master"
  project     = var.network_project_id
  network     = var.network
  priority    = 1000
  direction   = "EGRESS"

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  target_tags = [var.cluster_network_tag]
  destination_ranges = compact([
    var.master_ipv4_cidr_block,
    var.cluster_subnet_cidr,
    var.ip_range_pods,
  ])

  # Allow all possible protocols
  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
  allow { protocol = "sctp" }
  allow { protocol = "esp" }
  allow { protocol = "ah" }

}

/******************************************
  Allow GKE master to hit non 443 ports for
  Webhooks/Admission Controllers
  https://github.com/kubernetes/kubernetes/issues/79739
 *****************************************/
resource "google_compute_firewall" "master_webhooks" {
  name        = "fw-${var.environment_code}-${var.cluster_short_name}-i-a-gke-webhooks"
  description = "Managed by terraform gke module: Allow master to hit pods for admission controllers/webhooks"
  project     = var.network_project_id
  network     = var.network
  priority    = 1000
  direction   = "INGRESS"

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  source_ranges = [var.master_ipv4_cidr_block]
  target_tags   = [var.cluster_network_tag]

  allow {
    protocol = "tcp"
    ports    = var.webhooks_inbound_ports
  }


}


/******************************************
  Create shadow firewall rules to capture the
  traffic flow between the managed firewall rules
 *****************************************/
resource "google_compute_firewall" "shadow_allow_pods" {
  name        = "fw-${var.environment_code}-${var.cluster_short_name}-i-a-gke-shadow-all"
  description = "Managed by terraform gke module: A shadow firewall rule to match the default rule allowing pod communication."
  project     = var.network_project_id
  network     = var.network
  priority    = 999
  direction   = "INGRESS"

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  source_ranges = [var.ip_range_pods]
  target_tags   = [var.cluster_network_tag]

  # Allow all possible protocols
  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
  allow { protocol = "sctp" }
  allow { protocol = "esp" }
  allow { protocol = "ah" }

}

resource "google_compute_firewall" "shadow_allow_master" {
  name        = "fw-${var.environment_code}-${var.cluster_short_name}-i-a-gke-shadow-master"
  description = "Managed by terraform GKE module: A shadow firewall rule to match the default rule allowing master nodes communication."
  project     = var.network_project_id
  network     = var.network
  priority    = 999
  direction   = "INGRESS"

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  source_ranges = [var.master_ipv4_cidr_block]
  target_tags   = [var.cluster_network_tag]

  allow {
    protocol = "tcp"
    ports    = ["10250", "443"]
  }

}

resource "google_compute_firewall" "shadow_allow_nodes" {
  name        = "fw-${var.environment_code}-${var.cluster_short_name}-i-a-gke-shadow-vms"
  description = "Managed by Terraform GKE module: A shadow firewall rule to match the default rule allowing worker nodes communication."
  project     = var.network_project_id
  network     = var.network
  priority    = 999
  direction   = "INGRESS"

  dynamic "log_config" {
    for_each = var.firewall_enable_logging == true ? [{
      metadata = "INCLUDE_ALL_METADATA"
    }] : []

    content {
      metadata = log_config.value.metadata
    }
  }

  source_ranges = [var.cluster_subnet_cidr]
  target_tags   = [var.cluster_network_tag]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
    ports    = ["1-65535"]
  }

  allow {
    protocol = "tcp"
    ports    = ["1-65535"]
  }

}