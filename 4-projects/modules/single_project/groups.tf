# Allow prj admins to impersonate prj sa
resource "google_service_account_iam_member" "prjadmins_impersonate_prj_sa" {
  service_account_id = module.project.service_account_name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "group:${var.group_prj_admins}"
}

resource "google_project_iam_member" "project_admin" {
  project = module.project.project_id
  role    = "roles/editor"
  member  = "group:${var.group_prj_admins}"
}