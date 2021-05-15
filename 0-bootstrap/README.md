<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| google | >= 3.50 |
| null | ~> 2.1 |
| random | ~> 2.3 |

## Providers

| Name | Version |
|------|---------|
| google | >= 3.50 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| billing\_account | The ID of the billing account to associate projects with. | `string` | n/a | yes |
| bucket\_prefix | Name prefix to use for state bucket created. | `string` | `"bkt"` | no |
| cloud\_source\_repos | List of Cloud Source Repositories created during bootstrap project build stage for use with Cloud Build. | `list(string)` | <pre>[<br>  "gcp-org",<br>  "gcp-environments",<br>  "gcp-networks",<br>  "gcp-projects"<br>]</pre> | no |
| default\_region | Default region to create resources where applicable. | `string` | `"us-central1"` | no |
| folder\_prefix | Name prefix to use for folders created. Should be the same in all steps. | `string` | `"fldr"` | no |
| group\_billing\_admins | Google Group for GCP Billing Administrators | `string` | n/a | yes |
| group\_org\_admins | Google Group for GCP Organization Administrators | `string` | n/a | yes |
| org\_id | GCP Organization ID | `string` | n/a | yes |
| org\_policy\_admin\_role | Additional Org Policy Admin role for admin group. You can use this for testing purposes. | `bool` | `false` | no |
| org\_project\_creators | Additional list of members to have project creator role across the organization. Prefix of group: user: or serviceAccount: is required. | `list(string)` | `[]` | no |
| parent\_folder | Optional - for an organization with existing projects or for development/validation. It will place all the example foundation resources under the provided folder instead of the root organization. The value is the numeric folder ID. The folder must already exist. | `string` | `""` | no |
| project\_prefix | Name prefix to use for projects created. Should be the same in all steps. Max size is 3 characters. | `string` | `"prj"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cloudbuild\_project\_id | Project where CloudBuild configuration and terraform container image will reside. |
| csr\_repos | List of Cloud Source Repos created by the module, linked to Cloud Build triggers. |
| gcs\_bucket\_cloudbuild\_artifacts | Bucket used to store Cloud/Build artifacts in CloudBuild project. |
| gcs\_bucket\_tfstate | Bucket used for storing terraform state for foundations pipelines in seed project. |
| kms\_crypto\_key | KMS key created by the module. |
| kms\_keyring | KMS Keyring created by the module. |
| seed\_project\_id | Project where service accounts and core APIs will be enabled. |
| terraform\_sa\_name | Fully qualified name for privileged service account for Terraform. |
| terraform\_service\_account | Email for privileged service account for Terraform. |
| terraform\_validator\_policies\_repo | Cloud Source Repository created for terraform-validator policies. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
