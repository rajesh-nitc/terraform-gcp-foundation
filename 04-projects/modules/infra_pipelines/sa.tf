# IAM for Cloud Build SA to access cloudbuild_artifacts and tfstate buckets
resource "google_storage_bucket_iam_member" "buckets" {
  for_each = merge(local.artifact_buckets, local.state_buckets)
  bucket   = each.value
  role     = "roles/storage.admin"
  member   = "serviceAccount:${data.google_project.cloudbuild_project.number}@cloudbuild.gserviceaccount.com"
}

# Allow group to access tf state
resource "google_storage_bucket_iam_member" "tf_state_buckets" {
  for_each = local.state_buckets
  bucket   = each.value
  role     = "roles/storage.admin"
  member   = "group:${var.group_email}"
}

# Allow cloudbuild to access tf image in bootstrap cb project
resource "google_project_iam_member" "bootstrap_cb_project" {
  project = data.google_projects.bootstrap_cb_project.projects[0].project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${data.google_project.cloudbuild_project.number}@cloudbuild.gserviceaccount.com"
}

