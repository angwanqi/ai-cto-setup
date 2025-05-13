
resource "random_shuffle" "region" {
  input        = ["us-central1", "europe-west4", "asia-southeast1"]
  result_count = 1
}

resource "random_shuffle" "zone" {
  input        = ["a", "b", "c"]
  result_count = 3
}

module "tenant" {
  source = "./modules/tenant"

  network_name = "${var.resource_prefix}-vpc"
  project_id   = var.project_id
  region       = var.region

  project_users   = var.project_users
  resource_prefix = var.resource_prefix

  services = [
    "iam.googleapis.com",
    "compute.googleapis.com",
    "servicenetworking.googleapis.com",
    "notebooks.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "aiplatform.googleapis.com",
    "pubsub.googleapis.com",
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    "dataflow.googleapis.com",
    "bigquery.googleapis.com",
    "artifactregistry.googleapis.com",
    "language.googleapis.com",
    "documentai.googleapis.com",
    "storage.googleapis.com",
    "discoveryengine.googleapis.com",
    "cloudbilling.googleapis.com",
  ]

  subnets = [
    {
      subnet_name           = "asia-southeast1"
      subnet_ip             = "10.10.0.0/16"
      subnet_region         = "asia-southeast1"
      subnet_private_access = "true"
    },
    {
      subnet_name           = "europe-west4"
      subnet_ip             = "10.11.0.0/16"
      subnet_region         = "europe-west4"
      subnet_private_access = "true"
    },
    {
      subnet_name           = "us-central1"
      subnet_ip             = "10.12.0.0/16"
      subnet_region         = "us-central1"
      subnet_private_access = "true"
    },
    {
      subnet_name           = "asia-northeast3"
      subnet_ip             = "10.13.0.0/16"
      subnet_region         = "asia-northeast3"
      subnet_private_access = "true"
    },
    {
      subnet_name           = "asia-south1"
      subnet_ip             = "10.14.0.0/16"
      subnet_region         = "asia-south1"
      subnet_private_access = "true"
    },
    {
      subnet_name           = "europe-west2"
      subnet_ip             = "10.15.0.0/16"
      subnet_region         = "europe-west2"
      subnet_private_access = "true"
    },
    {
      subnet_name           = "us-east1"
      subnet_ip             = "10.16.0.0/16"
      subnet_region         = "us-east1"
      subnet_private_access = "true"
    },
    {
      subnet_name           = "us-east4"
      subnet_ip             = "10.17.0.0/16"
      subnet_region         = "us-east4"
      subnet_private_access = "true"
    },
    {
      subnet_name           = "us-west1"
      subnet_ip             = "10.18.0.0/16"
      subnet_region         = "us-west1"
      subnet_private_access = "true"
  }, ]
}
