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

variable "enable_private_endpoint" {
  type    = bool
  default = true
}

variable "deploy_using_private_endpoint" {
  type    = bool
  default = true
}

variable "project_service_account" {
  type        = string
  description = "Service account email of the account to impersonate to run Terraform."
}

variable "cluster_autoscaling" {
  type = object({
    enabled             = bool
    autoscaling_profile = string
    min_cpu_cores       = number
    max_cpu_cores       = number
    min_memory_gb       = number
    max_memory_gb       = number
    gpu_resources       = list(object({ resource_type = string, minimum = number, maximum = number }))
  })
  default = {
    enabled             = false
    autoscaling_profile = "BALANCED"
    max_cpu_cores       = 0
    min_cpu_cores       = 0
    max_memory_gb       = 0
    min_memory_gb       = 0
    gpu_resources       = []
  }
  description = "Cluster autoscaling configuration. See [more details](https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters#clusterautoscaling)"
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

variable "provision_bastion_instance" {
  type    = bool
  default = true
}

# rbac
variable "cluster_admin" {
  type = string
}

variable "rbac_test_user" {
  type = string
}