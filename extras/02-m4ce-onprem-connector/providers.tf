provider "vsphere" {
  # If you use a domain, set your login like this "Domain\\User"
  user           = var.vsphere_environment.vcenter_user
  password       = var.vcenter_password
  vsphere_server = var.vsphere_environment.vcenter_ip

  # If you have a self-signed cert
  allow_unverified_ssl = true
}