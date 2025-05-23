terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region

  billing_project = var.project_id
  user_project_override = true             # Crucial for enforcing the billing_project
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}
