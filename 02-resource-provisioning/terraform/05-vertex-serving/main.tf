data "terraform_remote_state" "base_infra" {
  backend = "local"

  config = {
    path = "../01-base-infra/terraform.tfstate"
  }
}

locals {
  project_id = data.terraform_remote_state.base_infra.outputs.project_id
  region     = data.terraform_remote_state.base_infra.outputs.region
  vpc_id     = data.terraform_remote_state.base_infra.outputs.vpc_id

  random_region    = data.terraform_remote_state.base_infra.outputs.random_region
  random_zone_list = data.terraform_remote_state.base_infra.outputs.random_zone_list

  resource_prefix = data.terraform_remote_state.base_infra.outputs.resource_prefix
  project_users   = data.terraform_remote_state.base_infra.outputs.project_users

  vertex_ai_region = data.terraform_remote_state.base_infra.outputs.vertex_ai_region

  lab_services = [
    "cloudquotas.googleapis.com",
  ]
}

# enable APIs
resource "google_project_service" "lab_services" {
  for_each = toset(local.lab_services)
  service  = each.value

  project = local.project_id

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
  disable_on_destroy         = false
}

# create/destroy serving endpoint
module "cli" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.0"
  
  platform = "linux"

  create_cmd_entrypoint = "${path.module}/scripts/vertex-endpoint.sh"
  create_cmd_body       = "create ${local.project_id} ${local.vertex_ai_region} ${local.resource_prefix}"

  destroy_cmd_entrypoint = "${path.module}/scripts/vertex-endpoint.sh"
  destroy_cmd_body       = "delete ${local.project_id} ${local.vertex_ai_region} ${local.resource_prefix}"
}
