# gcp-foundation 

gcp-foundation monorepo configured with Cloudbuild GitHub App triggers for each subfolder. Triggers are created manually to avoid making changes in the official [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation)) 

## 0-bootstrap
1. gcp repos and build triggers created automatically as part of official 0-bootstrap are kept but not used
1. Added some roles to tf sa and added role to cloudbuild sa to access artifactory repo with impersonation - to make 0-bootstrap work on cloudbuild

## 1-org
1. Disabled audit data access logs and log exports to cloud storage and pubsub

## findings
1. terraform sa and cloudbuild sa both needs permissions on a bucket or artifactory repo in case of impersonation