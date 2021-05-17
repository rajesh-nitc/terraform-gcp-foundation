# gcp-foundation 

gcp-foundation monorepo configured with Cloudbuild GitHub App triggers for each subfolder. Triggers are created manually to avoid making changes in the official [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation). 

## 0-bootstrap
1. Comment out backend.tf, provider.tf and apply terraform manually
1. Update backend.tf, provider.tf, cloudbuild-tf-*.yaml with values from terraform output
1. Integrate Github repo gcp-foundation with Cloud Build via Github App trigger 
1. Create 3 triggers manually: 0-bootstrap-plan, 0-bootstrap-pull-request-plan and 0-bootstrap-apply and configure them with included files filter as 0-bootstrap/** and custom cloudbuild yaml location as 0-bootstrap/cloudbuild-tf-apply.yaml for example for 0-bootstrap-apply trigger
1. gcp repos and build triggers created automatically as part of official 0-bootstrap are kept but not used
1. Added some roles to tf sa and added role to cloudbuild sa to access artifactory repo with impersonation - to make 0-bootstrap work on cloudbuild

## 1-org
1. Create 3 triggers manually with included files filter as 1-org/** and custom cloudbuild yaml location
1. Creating 2 projects: logging and dns hub until quota increase
1. Not creating hub n spoke projects until quota increase
1. Disabled audit data access logs and not sending log exports to cloud storage and pubsub

## findings
1. terraform sa and cloudbuild sa both needs permissions on a bucket or artifactory repo in case of impersonation