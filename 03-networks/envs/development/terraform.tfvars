org_id                    = "157305482127"
terraform_service_account = "org-terraform@prj-b-seed-6949.iam.gserviceaccount.com"
default_region1           = "us-central1"
default_region2           = "us-west1"
domain                    = "onprem.budita.dev."
enable_hub_and_spoke      = true

private_service_cidr = "10.16.64.0/21"

subnets = [

  # us-central1
  {
    team               = "bu1"
    subnet_ip          = "10.0.64.0/21"
    region             = "us-central1"
    secondary_ip_range = {}
  },
  {
    team               = "data"
    subnet_ip          = "10.0.72.0/21"
    region             = "us-central1"
    secondary_ip_range = {}
  },
  # GKE Address Management https://cloud.google.com/architecture/gke-address-management-options
  # one option is have a single gke subnet (with separate secondary ranges for separate clusters)
  # another option is have separate subnets for separate clusters
  # we will go with first
  {
    team      = "gke"
    subnet_ip = "10.0.80.0/21" # node cidr /21 : 1021–2044 nodes (host bits = 11)
    region    = "us-central1"
    secondary_ip_range = {
      # budita-usc1 cluster
      # node cidr /24 : 29–60 nodes (host bits = 6)
      # pod cidr /32-(6+8) : 65–110 pods per node
      # service cidr /24 : 129–256 ip addresses
      gke-budita-d-us-central1-pod = "100.64.64.0/18"  # {network_tag}-pod
      gke-budita-d-us-central1-svc = "100.64.128.0/24" # {network_tag}-svc
    }
  },
  {
    team               = "ad"
    subnet_ip          = "10.0.88.0/24"
    region             = "us-central1"
    secondary_ip_range = {}
  },
  {
    team               = "proxy-only"
    subnet_ip          = "10.0.89.0/24"
    region             = "us-central1"
    secondary_ip_range = {}
    purpose            = "REGIONAL_MANAGED_PROXY"
    role               = "ACTIVE"
  },

  # us-west1
  {
    team               = "bu1"
    subnet_ip          = "10.1.64.0/21"
    region             = "us-west1"
    secondary_ip_range = {}
  },
  {
    team               = "data"
    subnet_ip          = "10.1.72.0/21"
    region             = "us-west1"
    secondary_ip_range = {}
  },
  {
    team               = "gke"
    subnet_ip          = "10.1.80.0/21"
    region             = "us-west1"
    secondary_ip_range = {}
  },
  {
    team               = "ad"
    subnet_ip          = "10.1.88.0/24"
    region             = "us-west1"
    secondary_ip_range = {}
  },
  {
    team               = "proxy-only"
    subnet_ip          = "10.1.89.0/24"
    region             = "us-west1"
    secondary_ip_range = {}
    purpose            = "REGIONAL_MANAGED_PROXY"
    role               = "ACTIVE"
  },
]

# GKE
budita_usc1 = {
  master_ipv4_cidr_block = "100.64.129.0/28"
  network_tag            = "gke-budita-d-us-central1" # gke-{name}
}

# Enable nat for acm repo on github
nat_enabled = false

# DNS on demand
enable_dns_zone_private_googleapis = false
enable_dns_zone_gcr                = false # dataflow pull images from gcr.io
enable_dns_zone_pkg_dev            = false
enable_dns_peering                 = false

allow_all_ingress_ranges = [
  "10.2.0.0/24", # onprem
]

allow_all_egress_ranges = [
  "10.2.0.0/24", # onprem

]