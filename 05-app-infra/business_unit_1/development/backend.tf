terraform {
  backend "gcs" {
    bucket                      = "bu1-tfstate-6fbf"
    prefix                      = "terraform/app-infra/business_unit_1/development"
    impersonate_service_account = "project-service-account@prj-bu1-d-sample-base-9208.iam.gserviceaccount.com"
  }
}
