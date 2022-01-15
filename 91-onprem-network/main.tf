locals {
  private_googleapis_cidr = "199.36.153.8/30"
  dns_proxy_cidr          = "35.199.192.0/19"
}

module "main" {
  source                                 = "git@github.com:terraform-google-modules/terraform-google-network.git?ref=master"
  project_id                             = var.project_id
  network_name                           = "vpc-onprem"
  shared_vpc_host                        = false
  delete_default_internet_gateway_routes = true

  subnets = [
    {
      subnet_name           = "sb-onprem-${var.default_region1}"
      subnet_ip             = "10.2.0.0/24"
      subnet_region         = var.default_region1
      subnet_private_access = false
      subnet_flow_logs      = false
      description           = "First onprem subnet example."
    },
  ]
}