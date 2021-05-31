# App Repo Cloudbuild Build Trigger
resource "google_cloudbuild_trigger" "cicd_trigger" {
  for_each = toset(var.monorepo_folders)
  provider = google-beta
  project  = var.app_cicd_project_id
  name     = "${each.key}-trigger"

  github {
    name  = "gcp-foundation"
    owner = "rajesh-nitc"

    push {
      branch       = ".*"
      invert_regex = false
    }
  }

  included_files = ["${each.key}/**"]

  substitutions = {
    _GAR_REPOSITORY    = local.gar_name
    _DEFAULT_REGION    = var.primary_location
    _CACHE_BUCKET_NAME = google_storage_bucket.cache_bucket.name
    _CICD_BUILD_SA     = google_service_account.app_cicd_build_sa.email
  }

  filename = "${each.key}/${var.build_app_yaml}"
}