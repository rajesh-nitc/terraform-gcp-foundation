module "app_cicd_project" {
  source               = "../../../04-projects/modules/single_project"
  org_id               = var.org_id
  billing_account      = var.billing_account
  environment          = "common"
  alert_spent_percents = var.alert_spent_percents
  alert_pubsub_topic   = var.alert_pubsub_topic
  budget_amount        = var.budget_amount
  project_prefix       = var.project_prefix
  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "cloudbuild.googleapis.com",
    "sourcerepo.googleapis.com",
    "artifactregistry.googleapis.com",
    "containeranalysis.googleapis.com",
    # "containerscanning.googleapis.com", # To save cost
    "binaryauthorization.googleapis.com",
    # "secretmanager.googleapis.com", # Not using yet
    "compute.googleapis.com",
    "iam.googleapis.com",
    "container.googleapis.com",
    # "cloudkms.googleapis.com", # Not using yet
    "serviceusage.googleapis.com",
    "iamcredentials.googleapis.com",
  ]

  group_email = var.group_email

  # Metadata
  project_suffix    = "cicd-pipeline"
  application_name  = "app-cicd-pipelines"
  billing_code      = "1234"
  primary_contact   = "example@example.com"
  secondary_contact = "example2@example.com"
  business_code     = "gke"

}

module "cicd_pipeline" {
  source               = "../../../04-projects/modules/cicd_pipelines"
  app_cicd_project_id  = module.app_cicd_project.project_id
  monorepo_folders     = ["14-gke-app-cicd"]
  gar_repo_name_suffix = "cicd-image-repo"
  primary_location     = var.default_region
  # attestor_names_prefix = ["build", "quality", "security"]
  build_app_yaml   = "cloudbuild-pr.yaml"
  build_image_yaml = "cloudbuild-skaffold-build-image.yaml"
  group_email      = var.group_email
}