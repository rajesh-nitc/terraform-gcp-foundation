resource "vsphere_role" "gcp-m4ce-role" {
  name = local.m4ce_vcenter_role
  role_privileges = [
    "Global.DisableMethods",
    "Global.EnableMethods",
    "VirtualMachine.Config.ChangeTracking",
    "VirtualMachine.Interact.PowerOff",
    "VirtualMachine.Provisioning.DiskRandomRead",
    "VirtualMachine.Provisioning.GetVmFiles",
    "VirtualMachine.State.CreateSnapshot",
    "VirtualMachine.State.RemoveSnapshot"
  ]
}