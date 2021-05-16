/*************************************************
  Bootstrap GCP Organization.
*************************************************/
locals {
  parent = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
  org_admins_org_iam_permissions = var.org_policy_admin_role == true ? [
    "roles/orgpolicy.policyAdmin", "roles/resourcemanager.organizationAdmin", "roles/billing.user"
  ] : ["roles/resourcemanager.organizationAdmin", "roles/billing.user"]
}

resource "google_folder" "bootstrap" {
  display_name = "${var.folder_prefix}-bootstrap"
  parent       = local.parent
}

module "seed_bootstrap" {
  source                         = "terraform-google-modules/bootstrap/google"
  version                        = "~> 2.1"
  org_id                         = var.org_id
  folder_id                      = google_folder.bootstrap.id
  project_id                     = "${var.project_prefix}-b-seed"
  state_bucket_name              = "${var.bucket_prefix}-b-tfstate"
  billing_account                = var.billing_account
  group_org_admins               = var.group_org_admins
  group_billing_admins           = var.group_billing_admins
  default_region                 = var.default_region
  org_project_creators           = var.org_project_creators
  sa_enable_impersonation        = true
  parent_folder                  = var.parent_folder == "" ? "" : local.parent
  org_admins_org_iam_permissions = local.org_admins_org_iam_permissions
  project_prefix                 = var.project_prefix

  project_labels = {
    environment       = "bootstrap"
    application_name  = "seed-bootstrap"
    billing_code      = "1234"
    primary_contact   = "example1"
    secondary_contact = "example2"
    business_code     = "abcd"
    env_code          = "b"
  }

  activate_apis = [
    "serviceusage.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudkms.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "bigquery.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudbuild.googleapis.com",
    "iam.googleapis.com",
    "admin.googleapis.com",
    "appengine.googleapis.com",
    "storage-api.googleapis.com",
    "monitoring.googleapis.com",
    "pubsub.googleapis.com",
    "securitycenter.googleapis.com",
    "accesscontextmanager.googleapis.com",
    "billingbudgets.googleapis.com"
  ]

  sa_org_iam_permissions = [
    "roles/accesscontextmanager.policyAdmin",
    "roles/billing.user",
    "roles/compute.networkAdmin",
    "roles/compute.xpnAdmin",
    "roles/iam.securityAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/logging.configWriter",
    "roles/orgpolicy.policyAdmin",
    "roles/resourcemanager.projectCreator",
    "roles/resourcemanager.folderAdmin",
    "roles/securitycenter.notificationConfigEditor",
    "roles/resourcemanager.organizationViewer",
    "roles/storage.admin",            # Error when reading or editing Storage Bucket "prj-cloudbuild-artifacts-1b60": googleapi: Error 403: org-terraform@prj-b-seed-6949.iam.gserviceaccount.com does not have storage.buckets.get access to the Google Cloud Storage bucket., forbidden
    "roles/cloudkms.admin",           # Error when reading or editing KMSKeyRing "projects/prj-b-cicd-98fa/locations/us-central1/keyRings/tf-keyring": googleapi: Error 403: Permission 'cloudkms.keyRings.get' denied on resource 'projects/prj-b-cicd-98fa/locations/us-central1/keyRings/tf-keyring'
    "roles/cloudbuild.builds.editor", # Error when reading or editing CloudBuildTrigger "projects/prj-b-cicd-98fa/triggers/3022e24d-6439-4b43-ba44-c31ac4c46736": googleapi: Error 403: The caller does not have permission
    "roles/artifactregistry.admin"    # Error when reading or editing Resource "artifactregistry repository \"projects/prj-b-cicd-98fa/locations/us-central1/repositories/prj-tf-runners\"" with IAM Member: Role "roles/artifactregistry.writer" Member "serviceAccount:569736384662@cloudbuild.gserviceaccount.com": Error retrieving IAM policy for artifactregistry repository "projects/prj-b-cicd-98fa/locations/us-central1/repositories/prj-tf-runners": googleapi: Error 403: Permission 'artifactregistry.repositories.getIamPolicy' denied on resource '//artifactregistry.googleapis.com/projects/prj-b-cicd-98fa/locations/us-central1/repositories/prj-tf-runners'  
  ]
}

resource "google_billing_account_iam_member" "tf_billing_admin" {
  billing_account_id = var.billing_account
  role               = "roles/billing.admin"
  member             = "serviceAccount:${module.seed_bootstrap.terraform_sa_email}"
}

// Comment-out the cloudbuild_bootstrap module and its outputs if you want to use Jenkins instead of Cloud Build
module "cloudbuild_bootstrap" {
  source                      = "terraform-google-modules/bootstrap/google//modules/cloudbuild"
  version                     = "~> 2.1"
  org_id                      = var.org_id
  folder_id                   = google_folder.bootstrap.id
  project_id                  = "${var.project_prefix}-b-cicd"
  billing_account             = var.billing_account
  group_org_admins            = var.group_org_admins
  default_region              = var.default_region
  terraform_sa_email          = module.seed_bootstrap.terraform_sa_email
  terraform_sa_name           = module.seed_bootstrap.terraform_sa_name
  terraform_state_bucket      = module.seed_bootstrap.gcs_bucket_tfstate
  sa_enable_impersonation     = true
  cloudbuild_plan_filename    = "cloudbuild-tf-plan.yaml"
  cloudbuild_apply_filename   = "cloudbuild-tf-apply.yaml"
  project_prefix              = var.project_prefix
  cloud_source_repos          = var.cloud_source_repos
  terraform_validator_release = "2021-03-22"
  terraform_version           = "0.13.6"
  terraform_version_sha256sum = "55f2db00b05675026be9c898bdd3e8230ff0c5c78dd12d743ca38032092abfc9"

  activate_apis = [
    "serviceusage.googleapis.com",
    "servicenetworking.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "bigquery.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "admin.googleapis.com",
    "appengine.googleapis.com",
    "storage-api.googleapis.com",
    "billingbudgets.googleapis.com"
  ]

  project_labels = {
    environment       = "bootstrap"
    application_name  = "cloudbuild-bootstrap"
    billing_code      = "1234"
    primary_contact   = "example1"
    secondary_contact = "example2"
    business_code     = "abcd"
    env_code          = "b"
  }

  terraform_apply_branches = [
    "development",
    "non\\-production", //non-production needs a \ to ensure regex matches correct branches.
    "production"
  ]
}

// Standalone repo for Terraform-validator policies.
// This repo does not need to trigger builds in Cloud Build.
resource "google_sourcerepo_repository" "gcp_policies" {
  project = module.cloudbuild_bootstrap.cloudbuild_project_id
  name    = "gcp-policies"

  depends_on = [module.cloudbuild_bootstrap.csr_repos]
}

resource "google_project_iam_member" "project_source_reader" {
  project = module.cloudbuild_bootstrap.cloudbuild_project_id
  role    = "roles/source.reader"
  member  = "serviceAccount:${module.seed_bootstrap.terraform_sa_email}"

  depends_on = [module.cloudbuild_bootstrap.csr_repos]
}

data "google_project" "cloudbuild" {
  project_id = module.cloudbuild_bootstrap.cloudbuild_project_id

  depends_on = [module.cloudbuild_bootstrap.csr_repos]
}

resource "google_organization_iam_member" "org_cb_sa_browser" {
  count  = var.parent_folder == "" ? 1 : 0
  org_id = var.org_id
  role   = "roles/browser"
  member = "serviceAccount:${data.google_project.cloudbuild.number}@cloudbuild.gserviceaccount.com"
}

resource "google_folder_iam_member" "folder_cb_sa_browser" {
  count  = var.parent_folder != "" ? 1 : 0
  folder = var.parent_folder
  role   = "roles/browser"
  member = "serviceAccount:${data.google_project.cloudbuild.number}@cloudbuild.gserviceaccount.com"
}

resource "google_organization_iam_member" "org_tf_compute_security_policy_admin" {
  count  = var.parent_folder == "" ? 1 : 0
  org_id = var.org_id
  role   = "roles/compute.orgSecurityPolicyAdmin"
  member = "serviceAccount:${module.seed_bootstrap.terraform_sa_email}"
}

resource "google_folder_iam_member" "folder_tf_compute_security_policy_admin" {
  count  = var.parent_folder != "" ? 1 : 0
  folder = var.parent_folder
  role   = "roles/compute.orgSecurityPolicyAdmin"
  member = "serviceAccount:${module.seed_bootstrap.terraform_sa_email}"
}

resource "google_organization_iam_member" "org_tf_compute_security_resource_admin" {
  count  = var.parent_folder == "" ? 1 : 0
  org_id = var.org_id
  role   = "roles/compute.orgSecurityResourceAdmin"
  member = "serviceAccount:${module.seed_bootstrap.terraform_sa_email}"
}

resource "google_folder_iam_member" "folder_tf_compute_security_resource_admin" {
  count  = var.parent_folder != "" ? 1 : 0
  folder = var.parent_folder
  role   = "roles/compute.orgSecurityResourceAdmin"
  member = "serviceAccount:${module.seed_bootstrap.terraform_sa_email}"
}

# Required to allow cloud build to access artifact repo with impersonation.
resource "google_artifact_registry_repository_iam_member" "registry_access_with_impersonation" {
  provider = google-beta
  project  = module.cloudbuild_bootstrap.cloudbuild_project_id

  location   = var.default_region
  repository = module.cloudbuild_bootstrap.tf_runner_artifact_repo
  role       = "roles/artifactregistry.admin"
  member     = "serviceAccount:${data.google_project.cloudbuild.number}@cloudbuild.gserviceaccount.com"
}