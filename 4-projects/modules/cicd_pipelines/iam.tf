locals {
  cicd_tf_deploy_sa_roles = [
    "roles/viewer",
    "roles/storage.admin",
    "roles/cloudkms.admin",
    "roles/binaryauthorization.attestorsEditor",
    "roles/cloudkms.signerVerifier",
    "roles/containeranalysis.occurrences.editor",
    "roles/containeranalysis.notes.occurrences.viewer",
    "roles/containeranalysis.notes.attacher",
    "roles/container.developer",
    "roles/secretmanager.secretAccessor",
    "roles/containeranalysis.notes.editor",
    "roles/artifactregistry.admin",
    "roles/secretmanager.admin",
    "roles/source.admin",
    "roles/cloudbuild.builds.editor"
  ]
}

resource "google_service_account" "cicd_build_sa" {
  account_id  = "cicd-sa"
  description = "Service account to allow terraform to deploy shared resources in app_cicd project"
  project     = var.app_cicd_project_id
}

resource "google_project_iam_member" "cicd_sa_roles" {
  for_each = toset(local.cicd_tf_deploy_sa_roles)
  project  = var.app_cicd_project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.cicd_build_sa.email}"
}

resource "google_service_account_iam_member" "cloudbuild_sa_impersonate_cicd_sa" {
  service_account_id = google_service_account.cicd_build_sa.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${data.google_project.app_cicd_project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudbuild_sa_roles" {
  project = var.app_cicd_project_id
  role    = "roles/source.admin"
  member  = "serviceAccount:${data.google_project.app_cicd_project.number}@cloudbuild.gserviceaccount.com"
}

# Allow prj admins to impersonate cicd-sa
resource "google_service_account_iam_member" "prjadmins_impersonate_cicd_sa" {
  service_account_id = google_service_account.cicd_build_sa.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "group:${var.group_prj_admins}"
}