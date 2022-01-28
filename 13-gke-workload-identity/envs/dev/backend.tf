terraform {
  backend "gcs" {
    bucket                      = "11-gke-infra-tfstate-7864"
    prefix                      = "terraform/workload-identity/gke/development"
    impersonate_service_account = "project-service-account@prj-gke-d-clusters-3c96.iam.gserviceaccount.com"
  }
}
