## Vertex AI Training Resources

This Terraform module provisions resources for Vertex AI training, including enabling necessary APIs and creating a persistent resource using the gcloud CLI.

### Prerequisites

*   Terraform installed
*   Google Cloud SDK installed and configured
*   Base infrastructure module deployed (see `../01-base-infra`)

### Resources

*   **Google Project Services:** Enables the following APIs:
    *   `notebooks.googleapis.com`
    *   `cloudresourcemanager.googleapis.com`
    *   `aiplatform.googleapis.com`
    *   `pubsub.googleapis.com`
    *   `run.googleapis.com`
    *   `cloudbuild.googleapis.com`
    *   `dataflow.googleapis.com`
    *   `bigquery.googleapis.com`
    *   `artifactregistry.googleapis.com`
    *   `iam.googleapis.com`
    *   `ml.googleapis.com`
    *   `dialogflow.googleapis.com`
*   **Vertex AI Persistent Resource:** Creates a persistent resource for Vertex AI training using a custom script and the gcloud CLI.

### Inputs

This module relies on outputs from the base infrastructure module.  Specifically, it requires the following:

*   `project_id`: The Google Cloud project ID.
*   `region`: The Google Cloud region.
*   `vpc_id`: The VPC ID.
*   `random_region`: A randomly generated region.
*   `random_zone_list`: A list of randomly generated zones.
*   `resource_prefix`: A prefix for resource names.
*   `project_users`: A list of project users.
*   `vertex_ai_region`: The region for Vertex AI resources.

These values are retrieved from the `terraform.tfstate` file of the base infrastructure module.

### Outputs

This module does not currently define any outputs.

### Usage

1.  Ensure the base infrastructure module has been deployed.
2.  Initialize Terraform:
    ```bash
    terraform init
    ```
3.  Apply the configuration:
    ```bash
    terraform apply
    ```

### Scripts

The module uses a script (`scripts/persistent-resource.sh`) to manage the Vertex AI persistent resource.  This script should handle both creation and deletion of the resource based on the provided arguments.  **Note:** The contents of this script are not provided in the context and must be created separately.
