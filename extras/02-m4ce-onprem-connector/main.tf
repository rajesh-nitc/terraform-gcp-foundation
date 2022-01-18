locals {
  rsa-public-key                = file(var.m4ce_ssh_public_key)
  m4ce_vcenter_role             = "gcp-m4ce-role"
  m4ce_vcenter_user             = "gcp-m4ce-user"
  domain                        = element(split("@", var.vsphere_environment.vcenter_user), 1)
  m4ce_vcenter_user_with_domain = format("%s@%s", local.m4ce_vcenter_user, local.domain)

}

resource "vsphere_virtual_machine" "gcp-m4ce-connector" {
  name             = var.m4ce_appliance_properties.hostname
  resource_pool_id = data.vsphere_resource_pool.vsphere_pool.id
  datastore_id     = data.vsphere_datastore.vsphere_datastore.id
  host_system_id   = data.vsphere_host.vsphere_host.id
  datacenter_id    = data.vsphere_datacenter.vsphere_dc.id
  num_cpus         = 4
  memory           = 16384

  network_interface {
    network_id = data.vsphere_network.vsphere_network.id
  }

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  scsi_type = "lsilogic-sas"

  ovf_deploy {
    remote_ovf_url = var.m4ce_connector_ovf_url
  }

  vapp {
    properties = merge({ "public-keys" = local.rsa-public-key }, var.m4ce_appliance_properties)
  }
}