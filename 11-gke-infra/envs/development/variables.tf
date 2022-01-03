variable "org_id" {
  type = string
}

variable "project_service_account" {
  type        = string
  description = "Service account email of the account to impersonate to run Terraform."
}

variable "default_region" {
  type    = string
  default = "us-central1"
}