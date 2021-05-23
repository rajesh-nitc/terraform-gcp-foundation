module transformation_sa_iam {
  source            = "../data-iam"
  project_landing   = module.landing_project.project_id
  project_dwh       = module.dwh_project.project_id
  sa_transformation = module.transformation_project.sa
}
