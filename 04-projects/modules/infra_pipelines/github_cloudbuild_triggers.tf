resource "google_cloudbuild_trigger" "push_non_environment_branch" {
  for_each = toset(var.cloudbuild_trigger_repos)
  provider = google-beta
  project  = var.automation_project_id
  name     = "${each.key}-plan"

  github {
    name  = var.github_repo_name
    owner = var.github_user_name

    push {
      branch       = "^(development|production)$"
      invert_regex = true
    }
  }

  included_files = ["${each.key}/**"]

  substitutions = {
    _DEFAULT_REGION          = var.bucket_region
    _BOOTSTRAP_CB_PROJECT_ID = data.google_projects.bootstrap_cb_project.projects[0].project_id
  }

  filename = "${each.key}/cloudbuild-tf-plan.yaml"
}

resource "google_cloudbuild_trigger" "push_environment_branch" {
  for_each = toset(var.cloudbuild_trigger_repos)
  provider = google-beta
  project  = var.automation_project_id
  name     = "${each.key}-apply"

  github {
    name  = var.github_repo_name
    owner = var.github_user_name

    push {
      branch       = "^(development|production)$"
      invert_regex = false
    }
  }

  included_files = ["${each.key}/**"]

  substitutions = {
    _DEFAULT_REGION          = var.bucket_region
    _BOOTSTRAP_CB_PROJECT_ID = data.google_projects.bootstrap_cb_project.projects[0].project_id
  }

  filename = "${each.key}/cloudbuild-tf-apply.yaml"
}


