terraform {
  backend "gcs" {
    bucket                      = "data-tfstate-0546"
    prefix                      = "terraform/app-infra/data-lake-l0/development"
    impersonate_service_account = "project-service-account@prj-data-d-lake-l0-ffe8.iam.gserviceaccount.com"
  }
}
