provider "google" {
  impersonate_service_account = var.app_cicd_build_sa
}

provider "google-beta" {
  impersonate_service_account = var.app_cicd_build_sa
}
