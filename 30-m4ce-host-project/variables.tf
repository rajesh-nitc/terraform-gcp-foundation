variable "terraform_service_account" {
  description = "Service account email of the account to impersonate to run Terraform"
  type        = string
}

variable "org_id" {
  description = "The organization id for the associated services"
  type        = string
}

variable "billing_account" {
  description = "The ID of the billing account to associated this project with"
  type        = string
}

variable "group_email" {
  type = string
}

variable "target_projects" {
  type = list(string)
}

variable "host_project_id" {
  type = string
}