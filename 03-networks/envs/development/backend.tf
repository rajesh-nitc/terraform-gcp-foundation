terraform {
  backend "gcs" {
    bucket                      = "bkt-b-tfstate-e9c3"
    prefix                      = "terraform/networks/development"
    impersonate_service_account = "org-terraform@prj-b-seed-6949.iam.gserviceaccount.com"
  }
}
