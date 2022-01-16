variable "environment_code" {
  type        = string
  description = "A short form of the folder level resources (environment) within the Google Cloud organization."
}

variable "network_project_id" {
  type = string
}

variable "network" {
  type = string
}

variable "cluster_network_tag" {
  type = string
}

variable "cluster_endpoint_for_nodes" {
  type = string
}

variable "cluster_subnet_cidr" {
  type = string
}

variable "ip_range_pods" {
  type = string
}

variable "webhooks_inbound_ports" {
  type    = list(string)
  default = ["8443", "9443", "15017"]
}

variable "firewall_enable_logging" {
  type        = bool
  description = "Toggle firewall logging for VPC Firewalls."
  default     = true
}