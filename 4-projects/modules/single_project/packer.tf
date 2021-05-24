# Allow prj sa to access IAP tunnel
resource "google_project_iam_member" "prj_sa_iap_tunnel_user" {
  count   = var.use_iap ? 1 : 0
  project = module.project.project_id
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "serviceAccount:${module.project.service_account_email}"
}