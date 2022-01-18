variable "host_project_id" {
  type = string
}

variable "terraform_service_account" {
  description = "Service account email of the account to impersonate to run Terraform"
  type        = string
}

variable "domain_name" {
  type = string
}

variable "reserved_ip_range" {
  type = string
}

variable "network_name" {
  type = string
}

variable "regions" {
  type = list(string)
}