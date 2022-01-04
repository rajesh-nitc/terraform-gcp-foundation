data "vsphere_datacenter" "vsphere_dc" {
  name = var.vsphere_environment.data_center
}

data "vsphere_resource_pool" "vsphere_pool" {
  name          = var.vsphere_environment.resource_pool
  datacenter_id = data.vsphere_datacenter.vsphere_dc.id
}

data "vsphere_host" "vsphere_host" {
  name          = var.vsphere_environment.host_ip
  datacenter_id = data.vsphere_datacenter.vsphere_dc.id
}

data "vsphere_datastore" "vsphere_datastore" {
  name          = var.vsphere_environment.datastore
  datacenter_id = data.vsphere_datacenter.vsphere_dc.id
}

data "vsphere_network" "vsphere_network" {
  name          = var.vsphere_environment.virtual_net
  datacenter_id = data.vsphere_datacenter.vsphere_dc.id
}