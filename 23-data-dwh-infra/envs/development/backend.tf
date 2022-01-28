terraform {
  backend "gcs" {
    bucket                      = "data-tfstate-0546"
    prefix                      = "terraform/app-infra/data-dwh/development"
    impersonate_service_account = "project-service-account@prj-data-d-dwh-3f33.iam.gserviceaccount.com"
  }
}
