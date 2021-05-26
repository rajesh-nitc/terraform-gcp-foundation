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

module "app_cicd_project" {
  source                      = "../../../4-projects/modules/single_project"
  impersonate_service_account = var.terraform_service_account
  org_id                      = var.org_id
  billing_account             = var.billing_account
  environment                 = "common"
  alert_spent_percents        = var.alert_spent_percents
  alert_pubsub_topic          = var.alert_pubsub_topic
  budget_amount               = var.budget_amount
  project_prefix              = var.project_prefix
  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "cloudbuild.googleapis.com",
    "sourcerepo.googleapis.com",
    "artifactregistry.googleapis.com",
    "containeranalysis.googleapis.com",
    "containerscanning.googleapis.com",
    "binaryauthorization.googleapis.com",
    "secretmanager.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "container.googleapis.com",
    "cloudkms.googleapis.com",
    "anthos.googleapis.com",
    "serviceusage.googleapis.com"
  ]

  group_prj_admins = var.group_prj_admins

  # Metadata
  project_suffix    = "app-cicd"
  application_name  = "gke-app-pipelines"
  billing_code      = "1234"
  primary_contact   = "example@example.com"
  secondary_contact = "example2@example.com"
  business_code     = "gke"

}

resource "google_service_account" "app_cicd_build_sa" {
  account_id  = "cicd-build-sa"
  description = "Service account to allow terraform to deploy shared resources in app_cicd project"
  project     = module.app_cicd_project.project_id
}

resource "google_project_iam_member" "app_cicd_build_sa_roles" {
  for_each = toset(local.cicd_tf_deploy_sa_roles)
  project  = module.app_cicd_project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.app_cicd_build_sa.email}"
}

resource "google_service_account_iam_member" "app_cicd_build_sa_impersonate_permissions" {
  service_account_id = google_service_account.app_cicd_build_sa.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${module.app_infra_cloudbuild_project.project_number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "app_cicd_cloudbuild_sa_roles" {
  project = module.app_cicd_project.project_id
  role    = "roles/source.admin"
  member  = "serviceAccount:${module.app_cicd_project.project_number}@cloudbuild.gserviceaccount.com"
}


#############
module "cicd_pipeline" {
  source                = "../../modules/app_cicd_pipeline"
  app_cicd_build_sa     = var.app_cicd_build_sa
  app_cicd_project_id   = var.app_cicd_project_id
  app_cicd_repos        = ["bank-of-anthos-source", "root-config-repo", "accounts", "transactions", "frontend"]
  boa_build_repo        = "bank-of-anthos-source"
  gar_repo_name_suffix  = "boa-image-repo"
  primary_location      = var.primary_location
  attestor_names_prefix = ["build", "quality", "security"]
  build_app_yaml        = "cloudbuild-build-boa.yaml"
  build_image_yaml      = "cloudbuild-skaffold-build-image.yaml"
}