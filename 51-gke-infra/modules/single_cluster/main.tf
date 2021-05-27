locals {
  environment_code = element(split("", var.environment), 0)
  folder_id        = data.google_active_folder.env.name
  range_name_pod   = [for i in data.google_compute_subnetwork.subnetwork.secondary_ip_range : i.range_name if can(regex("pod", i.range_name))]
  range_name_svc   = [for i in data.google_compute_subnetwork.subnetwork.secondary_ip_range : i.range_name if can(regex("svc", i.range_name))]
  # bin_auth_attestors = [for attestor in var.bin_auth_attestor_names : "projects/${var.bin_auth_attestor_project_id}/attestors/${attestor}"]
  # allowlist_patterns = ["quay.io/random-containers/*", "k8s.gcr.io/more-random/*", "gcr.io/${var.boa_gke_project_id}/*", "gcr.io/config-management-release/*"] # Example
}

module "gke_cluster" {
  source = "git@github.com:terraform-google-modules/terraform-google-kubernetes-engine.git//modules/safer-cluster?ref=v14.3.0"

  project_id         = data.google_projects.gke_projects.projects[0].project_id
  network_project_id = data.google_project.network_project.project_id
  network            = data.google_compute_network.shared_vpc.name

  name                   = "gke-${local.environment_code}-${var.app_name}-${var.region}"
  subnetwork             = data.google_compute_subnetwork.subnetwork.name
  ip_range_pods          = local.range_name_pod[0]
  ip_range_services      = local.range_name_svc[0]
  master_ipv4_cidr_block = var.master_ipv4_cidr_block
  region                 = var.region
  master_authorized_networks = concat(var.master_authorized_networks,
    [
      {
        cidr_block   = "${module.bastion.ip_address}/32",
        display_name = "bastion in same subnet as cluster"
      }
    ]
  )
  cluster_resource_labels = {
    "mesh_id" = "proj-${data.google_project.gke_project.number}"
  }
  node_pools_tags = {
    "np-${var.region}" : ["gke-${var.app_name}-cluster", "allow-google-apis", "egress-internet", "allow-lb"]
  }
  node_pools = [
    {
      name               = "np-${var.region}",
      auto_repair        = true,
      auto_upgrade       = true,
      enable_secure_boot = true,
      image_type         = "COS_CONTAINERD",
      machine_type       = "e2-standard-4",
      max_count          = 3,
      min_count          = 1,
      node_metadata      = "GKE_METADATA_SERVER"
    }
  ]
  node_pools_oauth_scopes = {
    "all" : [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ],
    "default-node-pool" : []
  }
  compute_engine_service_account = "node-sa@${data.google_projects.gke_projects.projects[0].project_id}.iam.gserviceaccount.com"
}

module "bastion" {
  source                       = "../bastion"
  project_id                   = data.google_projects.gke_projects.projects[0].project_id
  bastion_name                 = "gce-bastion"
  bastion_zone                 = "${var.region}-a"
  bastion_service_account_name = "gce-bastion-sa"
  bastion_members              = var.bastion_members
  bastion_network_self_link    = data.google_compute_network.shared_vpc.self_link
  bastion_subnet_self_link     = data.google_compute_subnetwork.subnetwork.self_link
  bastion_region               = var.region
  network_project_id           = data.google_project.network_project.project_id
  # repo_project_id              = var.bin_auth_attestor_project_id
}

# resource "google_binary_authorization_policy" "policy" {
#   project = var.boa_gke_project_id

#   global_policy_evaluation_mode = "ENABLE"
#   default_admission_rule {
#     evaluation_mode         = "REQUIRE_ATTESTATION"
#     enforcement_mode        = var.enforce_bin_auth_policy ? "ENFORCED_BLOCK_AND_AUDIT_LOG" : "DRYRUN_AUDIT_LOG_ONLY"
#     require_attestations_by = local.bin_auth_attestors
#   }
#   dynamic "admission_whitelist_patterns" {
#     for_each = local.allowlist_patterns
#     content {
#       name_pattern = admission_whitelist_patterns.value
#     }
#   }
# }

# /******************************************
#  Cloud Armor policy
# *****************************************/

# resource "google_compute_security_policy" "cloud-armor-xss-policy" {
#   name    = "cloud-armor-xss-policy"
#   project = var.boa_gke_project_id
#   rule {
#     action   = "deny(403)"
#     priority = "1000"
#     match {
#       expr {
#         expression = "evaluatePreconfiguredExpr('xss-stable')"
#       }
#     }
#     description = "Cloud Armor policy to prevent cross-site scripting attacks."
#   }

#   rule {
#     action   = "allow"
#     priority = "2147483647"
#     match {
#       versioned_expr = "SRC_IPS_V1"
#       config {
#         src_ip_ranges = ["*"]
#       }
#     }
#     description = "default rule"
#   }
# }

# /******************************************
#  External IP Address
# *****************************************/

# resource "google_compute_global_address" "external_ip_for_http_load_balancing" {
#   name         = "mci-ip"
#   project      = var.boa_gke_project_id
#   address_type = "EXTERNAL"
#   description  = "External IP address for HTTP load balancing on MCI subnet."
# }