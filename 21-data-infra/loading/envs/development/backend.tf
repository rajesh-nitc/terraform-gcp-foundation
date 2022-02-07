terraform {
  backend "gcs" {
    bucket                      = "data-tfstate-0546"
    prefix                      = "terraform/app-infra/data-loading/development"
    impersonate_service_account = "project-service-account@prj-data-d-loading-82c5.iam.gserviceaccount.com"
  }
}
