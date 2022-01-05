resource "null_resource" "gcp-m4ce-user" {
  depends_on = [vsphere_role.gcp-m4ce-role]

  provisioner "local-exec" {
    command = <<EOT
    export GOVC_URL=https://${var.vsphere_environment.vcenter_ip}
    export GOVC_USERNAME=${var.vsphere_environment.vcenter_user}
    export GOVC_PASSWORD=${var.vcenter_password}
    export GOVC_DATASTORE=${data.vsphere_datastore.vsphere_datastore.id}
    export GOVC_DATACENTER=${data.vsphere_datacenter.vsphere_dc.id}
    export GOVC_INSECURE=true
    export GOVC_RESOURCE_POOL=${data.vsphere_resource_pool.vsphere_pool.id}
    govc sso.user.create -p ${var.m4ce_vcenter_user_password} -R ${local.m4ce_vcenter_role} ${local.m4ce_vcenter_user}
    govc permissions.set -principal ${local.m4ce_vcenter_user_with_domain} -propagate=true -role ${local.m4ce_vcenter_role}
    EOT

  }
}