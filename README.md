# gcp-foundation 

gcp-foundation monorepo configured with Cloudbuild GitHub App triggers (manual for now) for each subfolder

## 0-bootstrap
1. gcp repos and build triggers created automatically as part of official [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation)'s 0-bootstrap are kept but not used
1. Added some roles to tf sa and added role to cloudbuild sa to access artifactory repo with impersonation - to make 0-bootstrap work on cloudbuild

## findings
1. terraform sa and cloudbuild sa both needs permissions on a bucket or artifactory repo in case of impersonation