# Allow group to impersonate prj sa
resource "google_service_account_iam_member" "grp_impersonate_prj_sa" {
  service_account_id = module.project.service_account_name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "group:${var.group_email}"
}

# Group iam roles
resource "google_project_iam_member" "grp_roles" {
  for_each = toset(var.group_iam_roles)
  project = module.project.project_id
  role    = each.value
  member  = "group:${var.group_email}"
}