# Allow terraform-validator to access iam policies
# This will not be required by foundational pipelines, i guess
# This will be required by project infra pipelines, i guess
resource "google_folder_iam_member" "browser_cloud_build" {
  for_each = toset(var.folders_to_grant_browser_role)
  folder   = each.value
  role     = "roles/browser"
  member   = "serviceAccount:${data.google_project.automation_project.number}@cloudbuild.gserviceaccount.com"
}