variable "project_id" {
  type = string
}

variable "net_hub_project_id" {
  type = string
}

variable "dns_hub_project_id" {
  type = string
}

variable "dns_hub_self_link" {
  type = string
}

variable "net_hub_self_link" {
  type = string
}

variable "terraform_service_account" {
  description = "Service account email of the account to impersonate to run Terraform."
  type        = string
}

variable "default_region1" {
  type        = string
  description = "Default region 1"
}

variable "default_region2" {
  type        = string
  description = "Default region 2"
}

variable "firewall_enable_logging" {
  type        = bool
  description = "Toggle firewall logging for VPC Firewalls."
  default     = false
}

variable "domain" {
  type = string
}

variable "private_ip" {
  type = string
}

variable "hostname" {
  type = string
}

variable "gcp_default_region1_dev_range" {
  type = string
}
