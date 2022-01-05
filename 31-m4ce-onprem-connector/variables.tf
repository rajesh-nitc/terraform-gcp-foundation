variable "vsphere_environment" {
  description = "VMVware VSphere connection parameters"
  type = object({
    vcenter_ip    = string
    vcenter_user  = string
    data_center   = string
    resource_pool = string
    host_ip       = string
    datastore     = string
    virtual_net   = string
  })
}

variable "m4ce_appliance_properties" {
  description = "M4CE connector configuration parameters"
  type = object({
    hostname = string
    ip0      = string
    netmask0 = string
    gateway  = string
    DNS      = string
    proxy    = string
    route0   = string
  })
  default = {
    "hostname" = "gcp-m4ce-connector"
    "ip0"      = "0.0.0.0"
    "netmask0" = "0.0.0.0"
    "gateway"  = "0.0.0.0"
    "DNS"      = ""
    "proxy"    = ""
    "route0"   = ""
  }
}

variable "m4ce_ssh_public_key" {
  description = "Filesystem Path to the public key for the SSH login"
  type        = string
}

variable "vcenter_password" {
  type = string

}

variable "m4ce_connector_ovf_url" {
  description = "http URL to the public M4CE connector OVA image"
  type        = string
  default     = "https://storage.googleapis.com/vmmigration-public-artifacts/migrate-connector-2-0-1663.ova"
}

variable "m4ce_vcenter_user_password" {
  type = string
}