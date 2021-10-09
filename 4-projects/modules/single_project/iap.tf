# Allow group to access IAP tunnel
resource "google_project_iam_member" "grp_iap_tunnel_user" {
  count   = contains(var.activate_apis, "compute.googleapis.com") ? 1 : 0
  project = module.project.project_id
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "group:${var.group_email}"
}