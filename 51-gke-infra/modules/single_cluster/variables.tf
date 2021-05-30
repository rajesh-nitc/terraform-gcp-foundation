variable "org_id" {
  description = "The organization id for the associated services"
  type        = string
}

variable "parent_folder" {
  type    = string
  default = ""
}

variable "environment" {
  type = string
}

variable "project_prefix" {
  type        = string
  description = "Name prefix to use for projects created."
  default     = "prj"
}

variable "folder_prefix" {
  type        = string
  description = "Name prefix to use for folders created."
  default     = "fldr"
}

variable "region" {
  type        = string
  description = "The primary region for deployment, if not set default locations for each resource are taken from variables file."
  default     = "us-central1"
}

variable vpc_type {
  type    = string
  default = "base"
}

variable business_code {
  type    = string
  default = "gke"
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "The primary IPv4 cidr block for the first GKE cluster."
}

variable "app_name" {
  type = string
}

variable "master_authorized_networks" {
  type    = list(object({ cidr_block = string, display_name = string }))
  default = []
}

variable "node_pools" {
  type = list(map(string))
}

variable "groups_gke_security" {
  type = string
}

# Bastion
variable "bastion_zone" {
  type        = string
  description = "The zone for the bastion VM in primary region."
  default     = "us-central1-a"
}

variable "bastion_members" {
  type        = list(string)
  description = "The names of the members of the bastion server."
  default     = []
}