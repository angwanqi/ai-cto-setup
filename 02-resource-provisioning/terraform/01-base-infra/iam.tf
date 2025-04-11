locals {
  user_list = formatlist("user:%s", var.project_users)
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
    "compute.disks.get"
    ]
}

# bind custom lab_users role to users
resource "google_project_iam_binding" "project_users" {
  project = var.project_id
  role    = google_project_iam_custom_role.lab_users.name

  members = local.user_list
}
