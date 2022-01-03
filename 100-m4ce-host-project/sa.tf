resource "google_service_account" "m4ce_connector_sa" {
  project      = module.m4ce_host_project.project_id
  account_id   = "m4ce-connector-sa"
  display_name = "m4ce Connector SA"
}

resource "google_project_iam_member" "m4ce_connector_sa_roles" {
  for_each = toset(local.group_iam_roles)
  project  = module.m4ce_host_project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.m4ce_connector_sa.email}"
}