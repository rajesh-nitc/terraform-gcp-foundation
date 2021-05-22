locals {
  transformation_sa_roles_landing_project = [
    "roles/pubsub.admin",
    "roles/storage.admin",
  ]

  transformation_sa_roles_dwh_project = [
    "roles/bigquery.admin"
  ]
}

resource "google_project_iam_member" "transformation_sa_access_landing_project" {
  for_each = toset(local.transformation_sa_roles_landing_project)
  project  = var.project_landing
  role     = each.key
  member   = "serviceAccount:${var.sa_landing}"
}

resource "google_project_iam_member" "transformation_sa_access_dwh_project" {
  for_each = toset(local.transformation_sa_roles_dwh_project)
  project  = var.project_dwh
  role     = each.key
  member   = "serviceAccount:${var.sa_dwh}"
}