# TODO : Remove roles and apis that are not required

locals {
  gke_project_sa_roles = [
    "roles/compute.viewer",
    "roles/compute.instanceAdmin.v1",
    "roles/container.clusterAdmin",
    "roles/container.developer",
    "roles/viewer",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/resourcemanager.projectIamAdmin",
    "roles/logging.configWriter",
    "roles/storage.objectViewer",
    "roles/iap.admin",
    "roles/iam.roleAdmin",
    "roles/binaryauthorization.policyEditor",
    "roles/compute.securityAdmin",
    "roles/compute.publicIpAdmin",
    "roles/container.admin", # Required to create clusterroles for e.g. if acm is to be installed
    "roles/gkehub.admin",    # Need gkehub.features.create to enable acm in a project
  ]

  # project_sa_cicd_roles = [
  #   "roles/binaryauthorization.attestorsViewer",
  #   "roles/resourcemanager.projectIamAdmin",
  # ]
}

module gke_project {
  source                   = "../../../4-projects/modules/single_project"
  enable_hub_and_spoke     = true
  org_id                   = var.org_id
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
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "dns.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "storage.googleapis.com",
    "cloudtrace.googleapis.com",
    "stackdriver.googleapis.com",
    "cloudkms.googleapis.com",
    "secretmanager.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "meshca.googleapis.com",
    "meshtelemetry.googleapis.com",
    "meshconfig.googleapis.com",
    "iamcredentials.googleapis.com",
    "iam.googleapis.com",
    "gkeconnect.googleapis.com",
    "gkehub.googleapis.com",
    "anthos.googleapis.com",
    "billingbudgets.googleapis.com",
    "iap.googleapis.com",
    "storage-api.googleapis.com",
    "oslogin.googleapis.com",
    "binaryauthorization.googleapis.com",
    "privateca.googleapis.com",
    "containerscanning.googleapis.com",
    "multiclusteringress.googleapis.com",
    "serviceusage.googleapis.com"
  ]

  group_prj_admins = var.group_prj_admins

  # Metadata
  project_suffix    = "clusters"
  application_name  = "budita"
  billing_code      = "1234"
  primary_contact   = "example@example.com"
  secondary_contact = "example2@example.com"
  business_code     = "gke"
}