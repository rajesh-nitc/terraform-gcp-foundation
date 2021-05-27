# gcp-foundation 

This repo implements a reasonably secure foundation on google cloud. It is a monorepo where each folder has its own github app cloudbuild triggers.

Following [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation), [terraform-example-foundation-app](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app), [cloud-foundation-fabric](https://github.com/terraform-google-modules/cloud-foundation-fabric/tree/master/data-solutions)

## Final view
[gcp-org-hierarchy-viewer](https://github.com/GoogleCloudPlatform/professional-services/tree/main/tools/gcp-org-hierarchy-viewer) gives:

```
🏢 budita.dev (157305482127)
 +-- 📁 fldr-bootstrap (818226860401)
 |   +-- 📦 prj-b-seed-6949
 |   +-- 📦 prj-b-cicd-98fa
 +-- 📁 fldr-common (161434909087)
 |   +-- 📦 prj-gke-c-infra-pipeline-e6f5
 |   +-- 📦 prj-gke-c-cicd-pipeline-7989
 |   +-- 📦 prj-data-c-infra-pipeline-fb29
 |   +-- 📦 prj-bu1-c-infra-pipeline-eedb
 |   +-- 📦 prj-c-dns-hub-c4a2
 |   +-- 📦 prj-c-logging-8083
 +-- 📁 fldr-development (267943501446)
     +-- 📦 prj-gke-d-clusters-3c96
     +-- 📦 prj-data-d-landing-0816
     +-- 📦 prj-data-d-dwh-3f33
     +-- 📦 prj-data-d-transformation-4f2b
     +-- 📦 prj-bu1-d-sample-base-9208
     +-- 📦 prj-d-shared-base-21a3
```

## Steps

Clone this repo and create ```feature/initial``` and ```development``` branch from main

### 0-bootstrap
1. as org admin or as user running this, you should have 3 roles at org level: Billing Account Administrator, Folder Creator, Organization Administrator 
1. create groups mentioned in ```common.auto.tfvars``` at root, comment out the ```terraform_service_account``` in ```common.auto.tfvars``` at root and comment out ```backend.tf```,```provider.tf```,```github_cloudbuild_triggers.tf```,```cloudbuild-*``` in 0-bootstrap and apply terraform manually
1. uncomment and update the files 
1. connect github repo with cloudbuild project manually
1. now a push to ```feature/initial``` branch should trigger terraform plan and merging it with ```development``` should trigger terraform apply
1. cloud source repos and cloudbuild triggers created on them automatically as part of official ```0-bootstrap``` are kept but not used
1. added roles to tf sa and a role to cloudbuild sa to access artifactory - to make ```0-bootstrap``` work on cloudbuild

### 1-org
1. provision production projects per org: dns hub and logging
1. disabled audit data access logs and not sending log exports to cloud storage and pubsub

### 2-environments
1. provision base host project for development

### 3-networks
1. first provision shared environment manually
1. provision base shared vpc in base host project

### 4-projects
1. first provision common/shared cloudbuild project for bu1 manually
1. ```Error 400: Repository mapping does not exist``` : connect the repo
1. update cloudbuild_sa in ```business_unit_1.auto.tfvars``` 
1. reusing tf runner image from bootstrap
1. shared subnets per bu/team

### 5-app-infra
1. update ```bu1-development.auto.tfvars```, ```cloudbuild-*```,```backend.tf```
