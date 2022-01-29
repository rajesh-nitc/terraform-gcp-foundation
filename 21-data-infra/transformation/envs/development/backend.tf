terraform {
  backend "gcs" {
    bucket                      = "data-tfstate-0546"
    prefix                      = "terraform/app-infra/data-transformation/development"
    impersonate_service_account = "project-service-account@prj-data-d-transformation-4f2b.iam.gserviceaccount.com"
  }
}
