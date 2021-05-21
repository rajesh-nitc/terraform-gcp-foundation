locals {
  parent_id        = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
  artifact_buckets = { for repo in toset(var.monorepo_folders) : "${repo}-ab" => format("%s-%s-%s", repo, "cb-artifacts", random_id.suffix.hex) }
  state_buckets    = { for repo in toset(var.monorepo_folders) : "${repo}-tfstate" => format("%s-%s-%s", repo, "tfstate", random_id.suffix.hex) }
}

data "google_project" "cloudbuild_project" {
  project_id = var.cloudbuild_project_id
}

data "google_active_folder" "bootstrap" {
  display_name = "${var.folder_prefix}-bootstrap"
  parent       = local.parent_id
}

data "google_projects" "seed_project" {
  filter = "parent.id:${split("/", data.google_active_folder.bootstrap.name)[1]} labels.application_name=seed-bootstrap lifecycleState=ACTIVE"
}

# Buckets for state and artifacts
resource "random_id" "suffix" {
  byte_length = 2
}

resource "google_storage_bucket" "tfstate" {
  for_each                    = local.state_buckets
  project                     = var.cloudbuild_project_id
  name                        = each.value
  location                    = var.bucket_region
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket" "cloudbuild_artifacts" {
  for_each                    = local.artifact_buckets
  project                     = var.cloudbuild_project_id
  name                        = each.value
  location                    = var.bucket_region
  uniform_bucket_level_access = true
  versioning {
    enabled = false
  }
}

# IAM for Cloud Build SA to access cloudbuild_artifacts and tfstate buckets
resource "google_storage_bucket_iam_member" "buckets" {
  for_each = merge(local.artifact_buckets, local.state_buckets)
  bucket   = each.value
  role     = "roles/storage.admin"
  member   = "serviceAccount:${data.google_project.cloudbuild_project.number}@cloudbuild.gserviceaccount.com"
}

# Allow cloudbuild to access tf image in seed project
resource "google_project_iam_member" "artifactory_seed_project" {
  project = data.google_projects.seed_project.projects[0].project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${data.google_project.cloudbuild_project.number}@cloudbuild.gserviceaccount.com"
}

# IAM for admins
resource "google_project_iam_member" "org_admins_cloudbuild_editor" {
  project = var.cloudbuild_project_id
  role    = "roles/cloudbuild.builds.editor"
  member  = "group:${var.group_org_admins}"
}

resource "google_project_iam_member" "org_admins_cloudbuild_viewer" {
  project = var.cloudbuild_project_id
  role    = "roles/viewer"
  member  = "group:${var.group_org_admins}"
}
