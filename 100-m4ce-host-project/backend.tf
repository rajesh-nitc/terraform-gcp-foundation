terraform {
  backend "gcs" {
    bucket = "bkt-b-tfstate-e9c3"
    prefix = "terraform/projects/m4ce"
  }
}
