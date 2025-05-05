## Vertex AI Serving Endpoint

This Terraform module manages the creation and deletion of a Vertex AI serving endpoint. It leverages a shell script to interact with the Google Cloud CLI for endpoint management.

### Prerequisites

*   Terraform installed
*   Google Cloud SDK (gcloud) installed and configured
*   Access to a Google Cloud project with necessary permissions (e.g., Vertex AI Administrator)
*   Remote state configured in a previous Terraform run (specifically, the `01-base-infra` module) to provide project details and other necessary information.

### Inputs

The module relies on outputs from a remote Terraform state located at `../01-base-infra/terraform.tfstate`.  Key inputs include:

*   `project_id`: The Google Cloud project ID.
*   `region`: The Google Cloud region.
*   `vertex_ai_region`: The specific region for Vertex AI resources.
*   `resource_prefix`: A prefix used for naming resources.

### Functionality

The module performs the following actions:

1.  **Enables necessary APIs:** Ensures the `cloudquotas.googleapis.com` API is enabled in the specified project.
2.  **Creates a serving endpoint:** Executes the `scripts/vertex-endpoint.sh` script with the `create` command, passing the project ID, Vertex AI region, and resource prefix as arguments.
3.  **Deletes a serving endpoint:** Executes the `scripts/vertex-endpoint.sh` script with the `delete` command, using the same arguments as the create operation.

### Usage

1.  **Initialization:** Run `terraform init` to initialize the Terraform working directory and download necessary providers.
2.  **Planning:** Run `terraform plan` to review the changes that will be applied.
3.  **Application:** Run `terraform apply` to create the serving endpoint.  Confirm the action by typing `yes` when prompted.
4.  **Destruction:** Run `terraform destroy` to delete the serving endpoint. Confirm the action by typing `yes` when prompted.

### Scripts

The core logic for endpoint management is encapsulated in the `scripts/vertex-endpoint.sh` script. This script should handle the actual `gcloud` commands for creating and deleting the endpoint, using the provided arguments.  **Note:** The contents of this script are not provided in the Terraform configuration and must be created separately.
