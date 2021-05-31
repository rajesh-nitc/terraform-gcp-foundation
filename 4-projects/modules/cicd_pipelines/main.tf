locals {
  gar_name = split("/", google_artifact_registry_repository.cicd_runner_image_repo.name)[length(split("/", google_artifact_registry_repository.cicd_runner_image_repo.name)) - 1]
  folders  = ["cache/.m2/.ignore", "cache/.skaffold/.ignore", "cache/.cache/pip/wheels/.ignore"]
}

data "google_project" "app_cicd_project" {
  project_id = var.app_cicd_project_id
}

/***********************************************
 Cache Storage Bucket
 ***********************************************/

resource "google_storage_bucket" "cache_bucket" {
  project                     = var.app_cicd_project_id
  name                        = "${var.app_cicd_project_id}_cloudbuild"
  location                    = var.primary_location
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_object" "cache_bucket_folders" {
  for_each = toset(local.folders)
  name     = each.value
  content  = "/n"
  bucket   = google_storage_bucket.cache_bucket.name
}

resource "google_storage_bucket_iam_member" "cloudbuild_artifacts_iam" {
  bucket     = google_storage_bucket.cache_bucket.name
  role       = "roles/storage.admin"
  member     = "serviceAccount:${data.google_project.app_cicd_project.number}@cloudbuild.gserviceaccount.com"
  depends_on = [google_storage_bucket.cache_bucket]
}


/***********************************************
 Image Build
 ***********************************************/

resource "null_resource" "cicd_runner_image" {
  triggers = {
    project_id_cloudbuild_project = var.app_cicd_project_id
  }

  provisioner "local-exec" {
    command = <<EOT
      gcloud builds submit ${path.module}/cloud-build-builder/ \
      --project ${var.app_cicd_project_id} \
      --config=${path.module}/cloud-build-builder/${var.build_image_yaml} \
      --substitutions=_DEFAULT_REGION=${var.primary_location},_GAR_REPOSITORY=${local.gar_name} \
      --impersonate-service-account=${google_service_account.cicd_build_sa.email}
  EOT
  }

  depends_on = [google_service_account_iam_member.cloudbuild_sa_impersonate_cicd_sa]

}

/***********************************************
 GAR Image Repo
 ***********************************************/

resource "google_artifact_registry_repository" "cicd_runner_image_repo" {
  provider      = google-beta
  project       = var.app_cicd_project_id
  location      = var.primary_location
  repository_id = format("%s-%s", var.app_cicd_project_id, var.gar_repo_name_suffix)
  description   = "Docker repository for application images"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_member" "cloudbuild_sa_access_cicd_runner_image" {
  provider   = google-beta
  project    = var.app_cicd_project_id
  location   = google_artifact_registry_repository.cicd_runner_image_repo.location
  repository = google_artifact_registry_repository.cicd_runner_image_repo.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${data.google_project.app_cicd_project.number}@cloudbuild.gserviceaccount.com"
}
