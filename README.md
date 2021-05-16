# gcp-foundation 

gcp-foundation monorepo configured with Cloudbuild GitHub App triggers (manual for now) for each subfolder. For more details, refer [terraform-example-foundation](https://github.com/terraform-google-modules/terraform-example-foundation)

gcp repos and build triggers created automatically as part of 0-bootstrap is kept as of now but not used

## findings
1. terraform sa and cloudbuild sa both needs permissions on a bucket or artifactory repo in case of impersonation