locals {
  env_code               = element(split("", var.environment), 0)
  shared_vpc_mode        = var.enable_hub_and_spoke ? "-spoke" : ""
  svpc_host_project_id   = var.vpc_type == "" ? "" : data.google_compute_network.shared_vpc[0].project
  shared_vpc_subnets_map = var.vpc_type == "" ? {} : data.google_compute_subnetwork.shared_subnets
  shared_vpc_subnets     = var.vpc_type == "" ? [] : [for i in local.shared_vpc_subnets_map : i.self_link]
  iap_apis               = var.use_iap ? ["iap.googleapis.com"] : []
  default_apis = [
    "iam.googleapis.com",
    "iamcredentials.googleapis.com", # dependent on iam.googleapis.com
    "billingbudgets.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "storage.googleapis.com",
    "cloudtrace.googleapis.com",
    "stackdriver.googleapis.com",
  ]
  service_prj_gke_sa         = format("service-%s@container-engine-robot.iam.gserviceaccount.com", module.project.project_number)
  service_prj_google_apis_sa = format("%s@cloudservices.gserviceaccount.com", module.project.project_number)
  service_prj_dataflow_sa    = format("service-%s@dataflow-service-producer-prod.iam.gserviceaccount.com", module.project.project_number)
  service_prj_composer_sa    = format("service-%s@cloudcomposer-accounts.iam.gserviceaccount.com", module.project.project_number)
  service_prj_dataproc_sa    = format("service-%s@dataproc-accounts.iam.gserviceaccount.com", module.project.project_number)
  service_prj_vpc_access_sa  = format("service-%s@gcp-sa-vpcaccess.iam.gserviceaccount.com", module.project.project_number)
}

module "project" {
  source            = "terraform-google-modules/project-factory/google"
  version           = "~> 11.1"
  random_project_id = var.random_project_id
  activate_apis     = distinct(concat(var.activate_apis, local.default_apis, local.iap_apis))
  name              = "${var.project_prefix}-${var.business_code}-${local.env_code}-${var.project_suffix}"
  org_id            = var.org_id
  project_id        = var.project_id
  billing_account   = var.billing_account
  folder_id         = local.folder_id

  svpc_host_project_id = local.svpc_host_project_id
  shared_vpc_subnets   = local.shared_vpc_subnets

  vpc_service_control_attach_enabled = var.vpc_service_control_attach_enabled
  vpc_service_control_perimeter_name = var.vpc_service_control_perimeter_name

  labels = {
    environment       = var.environment
    application_name  = var.application_name
    billing_code      = var.billing_code
    primary_contact   = element(split("@", var.primary_contact), 0)
    secondary_contact = element(split("@", var.secondary_contact), 0)
    business_code     = var.business_code
    env_code          = local.env_code
    vpc_type          = var.vpc_type
  }
  budget_alert_pubsub_topic   = var.alert_pubsub_topic
  budget_alert_spent_percents = var.alert_spent_percents
  budget_amount               = var.budget_amount
}

