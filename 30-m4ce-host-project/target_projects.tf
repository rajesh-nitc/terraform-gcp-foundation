module "project_services" {
  for_each = toset(var.target_projects)
  source   = "terraform-google-modules/project-factory/google//modules/project_services"
  version  = "~> 11.1"

  project_id    = each.value
  activate_apis = local.activate_apis_target_projects

}

# Allow user to add target projects
resource "google_project_iam_member" "user_prj_iam_admin_target_prj" {
  for_each = toset(var.target_projects)
  project  = each.value
  role     = "roles/resourcemanager.projectIamAdmin"
  member   = "group:${var.group_email}"
}

# Allow m4ce default sa to assign sa's to instances in target projects
resource "google_project_iam_member" "m4ce_sa_sauser_target_prj" {
  for_each = toset(var.target_projects)
  project  = each.value
  role     = "roles/iam.serviceAccountUser"
  member   = "serviceAccount:${local.m4ce_default_sa}"
}