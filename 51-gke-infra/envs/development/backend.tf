terraform {
  backend "gcs" {
    bucket = "51-gke-infra-tfstate-7864"
    prefix = "terraform/app-infra/gke/development"
  }
}
