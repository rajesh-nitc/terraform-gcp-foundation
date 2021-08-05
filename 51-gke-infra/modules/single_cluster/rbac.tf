# Cluster Admin
resource "google_project_iam_member" "kube-api-admin" {
  project = local.project_id
  role    = "roles/container.admin"
  member  = "user:${var.cluster_admin}"
}

# Deleted custom roles prevent similarly named roles from being created for up to 30 days
resource "random_string" "role_suffix" {
  length  = 8
  special = false
}

# Allow a user to only authenticate
# Later this user will be given admin access to frontend namespace via acm
resource "google_project_iam_custom_role" "kube-api-ro" {
  project = local.project_id
  role_id = "kube_api_ro_${random_string.role_suffix.result}"

  title       = "Kubernetes API (RO)"
  description = "Grants read-only API access that can be further restricted with RBAC"

  permissions = [
    "container.apiServices.get",
    "container.apiServices.list",
    "container.clusters.get",
    "container.clusters.getCredentials",
  ]
}

resource "google_project_iam_binding" "kube-api-ro" {
  project = local.project_id
  role    = "projects/${local.project_id}/roles/${google_project_iam_custom_role.kube-api-ro.role_id}"

  members = [
    "user:${var.this_user_can_only_authenticate_with_cluster}",
  ]
}

# TODO : Use Google Groups for RBAC