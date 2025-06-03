locals {
  user_list = formatlist("user:%s", var.project_users)

  compute_engine_roles = [
    "roles/artifactregistry.admin",            # Artifact Registry Administrator
    "roles/bigquery.admin",                    # BigQuery Admin
    "roles/cloudbuild.builds.builder",         # Cloud Build Service Account
    "roles/storage.admin",                     # Storage Admin
    "roles/aiplatform.admin",                  # Vertex AI administrator
    "roles/aiplatform.featurestoreAdmin",      # Vertex AI Feature Store admin
    "roles/serviceusage.serviceUsageConsumer", # Service Usage Consumer
    "roles/iam.serviceAccountUser",            # Service Account User
    "roles/secretmanager.secretAccessor",      # Secrets Manager Secret Accessor
  ]

  project_user_roles = [
    "roles/resourcemanager.projectIamAdmin", # Project IAM Admin
    "roles/secretmanager.secretAccessor",    # Secrets Manager Secret Accessor
  ]
}

data "google_compute_default_service_account" "default" {
  project = var.project_id
}

# make users project editors - to tighten if schedule permits
resource "google_project_iam_binding" "project_editors" {
  project = var.project_id
  role    = "roles/editor"

  members = local.user_list
}

# custom role for lab users, any additional permissions required on top of Editor should be added here
resource "google_project_iam_custom_role" "lab_users" {
  role_id = "lab_user"
  title   = "lab_user"
  permissions = [
    "storage.objects.create",
    "storage.objects.delete",
    "storage.objects.get",
    "storage.objects.getIamPolicy",
    "storage.objects.list",
    "storage.objects.move",
    "storage.objects.overrideUnlockedRetention",
    "storage.objects.restore",
    "storage.objects.setIamPolicy",
    "storage.objects.setRetention",
    "storage.objects.update",
  ]
}

# bind custom lab_users role to users
resource "google_project_iam_binding" "project_users" {
  project = var.project_id
  role    = google_project_iam_custom_role.lab_users.name
  members = local.user_list
}

# bind some built-in roles to users
resource "google_project_iam_binding" "project_user_required_roles" {
  for_each = toset(local.project_user_roles)

  project = var.project_id
  role    = each.value
  members = local.user_list
}

# bind roles to default compute service account
resource "google_project_iam_binding" "compute_engine_required_roles" {
  for_each = toset(local.compute_engine_roles)
  project  = var.project_id
  role     = each.value
  members = [
    "serviceAccount:${data.google_compute_default_service_account.default.email}",
  ]
}

# allow project users to use default compute engine service account
resource "google_service_account_iam_binding" "admin-account-iam" {
  service_account_id = data.google_compute_default_service_account.default.name
  role               = "roles/iam.serviceAccountUser"

  members = local.user_list
}

resource "google_org_policy_policy" "allow_external_ip" {
  name   = "projects/${var.project_id}/policies/compute.vmExternalIpAccess"
  parent = "projects/${var.project_id}"

  spec {
    rules {
      allow_all = "TRUE"
    }
  }
}