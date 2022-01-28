terraform {
  backend "gcs" {
    bucket                      = "data-tfstate-0546"
    prefix                      = "terraform/app-infra/data-landing/development"
    impersonate_service_account = "project-service-account@prj-data-d-landing-0816.iam.gserviceaccount.com"
  }
}
