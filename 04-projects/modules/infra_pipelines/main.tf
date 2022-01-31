locals {
  parent_id = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
}

# Buckets for state and artifacts
resource "random_id" "suffix" {
  byte_length = 2
}

# For simplicity, one tfstate bucket per bu for all environments
resource "google_storage_bucket" "tfstate" {
  #checkov:skip=CKV_GCP_62:Bucket should log access
  project                     = var.automation_project_id
  name                        = format("%s-%s-%s", var.business_code, "tfstate", random_id.suffix.hex)
  location                    = var.bucket_region
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}


resource "google_storage_bucket" "cloudbuild_artifacts" {
  #checkov:skip=CKV_GCP_62:Bucket should log access
  project                     = var.automation_project_id
  name                        = format("%s-%s-%s", var.business_code, "cbartifacts", random_id.suffix.hex)
  location                    = var.bucket_region
  uniform_bucket_level_access = true
  versioning {
    enabled = false
  }
}
