# gcp-foundation 

Following the official [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation)

This repo is a monorepo where each folder has its own GitHub App Cloudbuild triggers

This repo provisions limited projects because of [billing-quota-increase](https://support.google.com/code/contact/billing_quota_increase)

Clone this repo and create ```feature/initial``` and ```development``` branch from main

## 0-bootstrap
1. as org admin, create groups mentioned in ```common.auto.tfvars``` at root, comment out the ```terraform_service_account``` in ```common.auto.tfvars``` at root and comment out ```backend.tf```, ```provider.tf```, ```github_cloudbuild_triggers.tf``` in 0-bootstrap and apply terraform manually
1. uncomment and update the files 
1. connect Github repo with cloudbuild project manually
1. now a push to ```feature/initial``` branch should trigger terraform plan and merging it with ```development``` should trigger terraform apply
1. cloud source repos and cloudbuild triggers created on them automatically as part of official ```0-bootstrap``` are kept but not used
1. To make ```0-bootstrap``` work on cloudbuild: Had to add roles to tf sa and a single role to cloudbuild sa 

## 1-org
1. creating 2 projects: logging and dns hub until quota increase
1. not creating hub n spoke projects until quota increase
1. disabled audit data access logs and not sending log exports to cloud storage and pubsub

## 2-environments
1. creating development host project only and not restricted host project

## 3-networks
1. first deploy shared environment manually
1. creating development shared vpc only and not restricted shared vpc

Not yet applied because of quota issue:

## 4-projects
1. first deploy shared cloudbuild project for bu1 in common folder manually i.e. 1 cloudbuild project per bu
1. Reusing the tf runner image from seed project
1. Allow Project SA to access TF state bucket - is this required?

## 5-app-infra
1. creating app-infra for development only