# Allow project sa to access tf state
resource "google_storage_bucket_iam_member" "tf_state_bucket" {
  bucket = var.bkt_tfstate
  role   = "roles/storage.admin"
  member = "serviceAccount:${module.gke_project.sa}"
}