locals {
  gke_project_sa_roles = [
    "roles/container.admin",       # Required to create clusterroles for e.g. if acm is to be installed
    "roles/gkehub.admin",          # Need gkehub.features.create to enable acm in a project
    "roles/compute.securityAdmin", # Required even if we are managing gke firewall rules separately
    "roles/iam.roleAdmin",         # Provides access to all custom roles in the project
    "roles/compute.viewer",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/resourcemanager.projectIamAdmin",
    # "roles/binaryauthorization.policyEditor", # Not using yet
  ]

  # project_sa_cicd_roles = [
  #   "roles/binaryauthorization.attestorsViewer",
  #   "roles/resourcemanager.projectIamAdmin",
  # ]
}

module "gke_project" {
  source                   = "../../../4-projects/modules/single_project"
  enable_hub_and_spoke     = true
  org_id                   = var.org_id
  random_project_id        = false
  project_id               = var.project_id
  billing_account          = var.billing_account
  environment              = var.environment
  vpc_type                 = "base"
  alert_spent_percents     = var.alert_spent_percents
  alert_pubsub_topic       = var.alert_pubsub_topic
  budget_amount            = var.budget_amount
  project_prefix           = var.project_prefix
  sa_roles                 = local.gke_project_sa_roles
  enable_cloudbuild_deploy = true
  cloudbuild_sa            = var.app_infra_pipeline_cloudbuild_sa
  activate_apis = [
    # general
    "compute.googleapis.com",
    "dns.googleapis.com",
    # gke
    "container.googleapis.com",
    # acm
    "gkehub.googleapis.com",
    # cicd
    # "binaryauthorization.googleapis.com",
    # "containerscanning.googleapis.com",
    # "cloudkms.googleapis.com",
    # "secretmanager.googleapis.com",
  ]

  group_email = var.group_email

  # Metadata
  project_suffix    = "clusters"
  application_name  = "budita"
  billing_code      = "1234"
  primary_contact   = "example@example.com"
  secondary_contact = "example2@example.com"
  business_code     = "gke"
}