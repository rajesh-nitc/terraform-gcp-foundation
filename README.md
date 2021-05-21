# gcp-foundation 

Following the official [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation)

This repo is a monorepo where each folder has its own github app cloudbuild triggers

This repo provisions limited projects. Gooogle Cloud provides 5 projects by default and i have got the [approval for additional 10](https://support.google.com/code/contact/billing_quota_increase) by paying $10. Out of total 15, we will be consuming 7 projects from ```0-bootstrap``` to ```5-app-infra``` and keeping rest for future use.

## Final view (0-bootstrap to 5-app-infra)
[gcp-org-hierarchy-viewer](https://github.com/GoogleCloudPlatform/professional-services/tree/main/tools/gcp-org-hierarchy-viewer) gives:

```
🏢 budita.dev (157305482127)
 +-- 📁 fldr-bootstrap (818226860401)
 |   +-- 📦 prj-b-seed-6949
 |   +-- 📦 prj-b-cicd-98fa
 +-- 📁 fldr-common (161434909087)
 |   +-- 📦 prj-bu1-c-infra-pipeline-eedb
 |   +-- 📦 prj-c-dns-hub-c4a2
 |   +-- 📦 prj-c-logging-8083
 +-- 📁 fldr-development (267943501446)
     +-- 📦 prj-bu1-d-sample-base-9208
     +-- 📦 prj-d-shared-base-21a3
```

## Steps

Clone this repo and create ```feature/initial``` and ```development``` branch from main

### 0-bootstrap
1. as org admin or as user running this, you should have 3 roles at org level: Billing Account Administrator, Folder Creator, Organization Administrator 
1. create groups mentioned in ```common.auto.tfvars``` at root, comment out the ```terraform_service_account``` in ```common.auto.tfvars``` at root and comment out ```backend.tf```, ```provider.tf```, ```github_cloudbuild_triggers.tf``` in 0-bootstrap and apply terraform manually
1. uncomment and update the files 
1. connect github repo with cloudbuild project manually
1. now a push to ```feature/initial``` branch should trigger terraform plan and merging it with ```development``` should trigger terraform apply
1. cloud source repos and cloudbuild triggers created on them automatically as part of official ```0-bootstrap``` are kept but not used
1. to make ```0-bootstrap``` work on cloudbuild: had to add roles to tf sa and a single role to cloudbuild sa 

### 1-org
1. creating 2 common projects: logging and dns hub
1. not creating hub n spoke projects - for now
1. disabled audit data access logs and not sending log exports to cloud storage and pubsub

### 2-environments
1. creating base host project for development only

### 3-networks
1. first provision shared environment manually
1. creating base shared vpc in the base host project

### 4-projects
1. first provision common/shared cloudbuild project for bu1 manually
1. you will get ```Error creating Trigger: googleapi: Error 400: Repository mapping does not exist. Please visit```. visit the link and connect github repo to common cloudbuild project for bu1
1. from terraform outputs, update the cloudbuild_sa in ```business_unit_1.auto.tfvars``` 
1. we are creating 1 dev service project for bu1 (attached to dev base host project)
1. reusing the tf runner image from bootstrap cloudbuild project
1. allow project SA to access TF state bucket - is this required?

### 5-app-infra
1. update project sa in ```bu1-development.auto.tfvars```, ```cloudbuild-tf-plan.yaml```, ```cloudbuild-tf-apply.yaml``` and bucket in ```backend.tf``` 
1. deploying app-infra in the dev service project for bu1