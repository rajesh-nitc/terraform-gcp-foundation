# IAP tunnel

# seems to work without enabling iap.googleapis.com?
resource "google_project_iam_member" "prj_sa_iap_tunnel_user" {
  count   = contains(var.activate_apis, "compute.googleapis.com") ? 1 : 0
  project = module.project.project_id
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "serviceAccount:${module.project.service_account_email}"
}

resource "google_project_iam_member" "prjadmins_iap_tunnel_user" {
  count   = contains(var.activate_apis, "compute.googleapis.com") ? 1 : 0
  project = module.project.project_id
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "group:${var.group_prj_admins}"
}