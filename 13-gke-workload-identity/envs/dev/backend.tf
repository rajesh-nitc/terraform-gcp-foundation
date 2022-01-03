terraform {
  backend "gcs" {
    bucket = "11-gke-infra-tfstate-7864"
    prefix = "terraform/workload-identity/gke/development"
  }
}
