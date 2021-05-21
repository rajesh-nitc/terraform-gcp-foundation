/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "impersonate_service_account" {
  description = "Service account email of the account to impersonate to run Terraform"
  type        = string
}

variable "project_prefix" {
  description = "Name prefix to use for projects created."
  type        = string
  default     = "prj"
}

variable "cloudbuild_project_id" {
  description = "The project id where the pipelines and repos should be created"
  type        = string
}

variable "bucket_region" {
  description = "Region to create GCS buckets for tfstate and Cloud Build artifacts"
  type        = string
  default     = "us-central1"
}

variable "business_code" {
  description = "The code that describes which business unit owns the project e.g. bu1"
  type        = string
}

variable "parent_folder" {
  description = "Optional - for an organization with existing projects or for development/validation. It will place all the example foundation resources under the provided folder instead of the root organization. The value is the numeric folder ID. The folder must already exist. Must be the same value used in previous step."
  type        = string
  default     = ""
}

variable "org_id" {
  type        = string
  description = "Organization ID"
}

variable "folder_prefix" {
  description = "Name prefix to use for folders created. Should be the same in all steps."
  type        = string
  default     = "fldr"
}

variable "monorepo_folders" {
  type = list(string)
}