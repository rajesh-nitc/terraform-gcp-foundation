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
  project_suffix    = "cicd-pipeline"
  application_name  = "app-cicd-pipelines"
  billing_code      = "1234"
  primary_contact   = "example@example.com"
  secondary_contact = "example2@example.com"
  business_code     = "gke"

}

module "cicd_pipeline" {
  source               = "../../../4-projects/modules/cicd_pipelines"
  app_cicd_project_id  = module.app_cicd_project.project_id
  monorepo_folders     = ["54-gke-app-cicd"]
  gar_repo_name_suffix = "cicd-image-repo"
  primary_location     = var.default_region
  # attestor_names_prefix = ["build", "quality", "security"]
  build_app_yaml   = "cloudbuild-cicd.yaml"
  build_image_yaml = "cloudbuild-skaffold-build-image.yaml"
  group_prj_admins = var.group_prj_admins
}