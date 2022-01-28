terraform {
  backend "gcs" {
    bucket                      = "bkt-b-tfstate-e9c3"
    prefix                      = "terraform/onprem-infra/state"
    impersonate_service_account = "project-service-account@prj-onprem-o-connectivity-53cd.iam.gserviceaccount.com"
  }
}
