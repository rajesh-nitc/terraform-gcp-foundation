# gcp-foundation 

Example repo showing how to build a secure foundation for quick prototyping and testing. It is made up of following parts:

- **foundations**: core (0* and $vpc-sc), gke (1*), data (2*)
- **onprem connectivity**: sample infra and connectivity tests (9*)

Credit to [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation), [terraform-example-foundation-app](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app), [cloud-foundation-fabric](https://github.com/terraform-google-modules/cloud-foundation-fabric)

## Org Hierarchy view
Credit to [gcp-org-hierarchy-viewer](https://github.com/GoogleCloudPlatform/professional-services/tree/main/tools/gcp-org-hierarchy-viewer)
```
🏢 budita.dev (157305482127)
 +-- 📁 fldr-bootstrap (818226860401)
 |   +-- 📦 prj-b-seed-6949
 |   +-- 📦 prj-b-cicd-98fa
 +-- 📁 fldr-common (161434909087)
 |   +-- 📦 prj-m4ce-c-host-11c7
 |   +-- 📦 prj-c-base-net-hub-74f5
 |   +-- 📦 prj-gke-c-infra-pipeline-e6f5
 |   +-- 📦 prj-gke-c-cicd-pipeline-7989
 |   +-- 📦 prj-data-c-infra-pipeline-fb29
 |   +-- 📦 prj-bu1-c-infra-pipeline-eedb
 |   +-- 📦 prj-c-dns-hub-c4a2
 |   +-- 📦 prj-c-logging-8083
 +-- 📁 fldr-development (267943501446)
 |   +-- 📦 prj-ad-d-mgmt-6b1d
 |   +-- 📦 prj-gke-d-clusters-3c96
 |   +-- 📦 prj-data-d-landing-0816
 |   +-- 📦 prj-data-d-dwh-3f33
 |   +-- 📦 prj-data-d-transformation-4f2b
 |   +-- 📦 prj-bu1-d-sample-base-9208
 |   +-- 📦 prj-d-shared-base-21a3
 +-- 📁 fldr-onprem (261068120484)
     +-- 📦 prj-onprem-o-connectivity-53cd
```
## Org IP Address Space view

```
🏢 budita.dev
- us-central1 10.0.0.0/16
  - Hub 10.0.0.0/18
    - sb 10.0.0.0/24
  - Dev 10.0.64.0/18
    - bu1 10.0.64.0/21
    - data 10.0.72.0/21
    - gke 10.0.80.0/21
    - ad-mgmt 10.0.88.0/24
    - proxy-only 10.0.89.0/24
- us-west1 10.1.0.0/16
  - Hub 10.1.0.0/18
    - sb 10.1.0.0/24
  - Dev 10.1.64.0/18
    - bu1 10.1.64.0/21
    - data 10.1.72.0/21
    - gke 10.1.80.0/21
    - ad-mgmt 10.1.88.0/24
    - proxy-only 10.1.89.0/24
- Dev Private Service 10.16.64.0/21
  - ad-domain 10.16.64.0/24
```

## Org GKE Admins Repo view

```
🏢 budita.dev
.
├── budita-app
│   ├── acm
│   │   ├── cluster
│   │   │   └── privileged-container-constraint.yaml
│   │   ├── namespaces
│   │   │   └── frontend
│   │   │       ├── admin-role-binding.yaml
│   │   │       ├── allow-all-ingress-networkpolicy.yaml
│   │   │       ├── istio-egress-googleapis.yaml
│   │   │       ├── istio-egress-metadata.yaml
│   │   │       ├── namespace.yaml
│   │   │       └── quota.yaml
│   │   └── system
│   │       ├── README.md
│   │       └── repo.yaml
│   └── kustomize-bases
│       └── frontend
│           ├── deployment.yaml
│           ├── istio-gateway.yaml
│           ├── istio-route.yaml
│           ├── ksa.yaml
│           ├── kustomization.yaml
│           └── service.yaml
└── README.md
```
## Org Validations
- Core foundation infra pipelines
- Project level infra and cicd pipelines
- Sample app in private gke cluster
- Sample dataflow pipelines
- Sample onprem connectivity tests

## Org Costs
To keep costs down in personal org:  

- Enable dns zones on demand
- Disable container scanning api
- Skip hierarchical firewall policies
- Skip kms
- Create log sink to send _only_ vpc-sc violations
- Clean artifact registry images in cicd projects

**Warning**: Don't enable firewall insights api as it is a costly operation