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

  models = [
    {
      display_name     = "sdxl"
      model            = "stability-ai/stable-diffusion-xl-base@stable-diffusion-xl-base-1.0"
      machine_type     = "a2-ultragpu-1g"
      accelerator_type = "NVIDIA_A100_80GB"
    },
    {
      display_name     = "gemma"
      model            = "google/gemma3@gemma-3-1b-it"
      machine_type     = "g2-standard-12"
      accelerator_type = "NVIDIA_L4"
    }
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
module "model_endpoints" {
  source   = "terraform-google-modules/gcloud/google"
  version  = "~> 3.0"
  platform = "linux"

  for_each = { for model in local.models : model.display_name => model }

  create_cmd_entrypoint = "${path.module}/scripts/vertex-endpoint.sh"
  create_cmd_body       = "create ${local.project_id} ${local.vertex_ai_region} ${local.resource_prefix}-${each.value.display_name} ${each.value.model} ${each.value.machine_type} ${each.value.accelerator_type}"

  destroy_cmd_entrypoint = "${path.module}/scripts/vertex-endpoint.sh"
  destroy_cmd_body       = "delete ${local.project_id} ${local.vertex_ai_region} ${local.resource_prefix}-${each.value.display_name} ${each.value.model} ${each.value.machine_type} ${each.value.accelerator_type}"
}
