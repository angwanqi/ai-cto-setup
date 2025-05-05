# Cloud AI Takeoff - Base Infrastructure

# 01-base-infra

This folder contains the Terraform configuration for setting up the base infrastructure for the AI platform.

## Files

- `iam.tf`: This file defines the IAM roles and bindings for the project, including custom roles for lab users and bindings for the default compute service account.
- `main.tf`: This file orchestrates the creation of the core infrastructure components by calling the `tenant` module and defining random resources for region and zone selection.
- `output.tf`: This file defines the output variables that will be displayed after the Terraform configuration is applied, providing information about the created resources.
- `providers.tf`: This file configures the Google Cloud provider and specifies the required provider versions.
- `variables.tf`: This file defines the input variables for the Terraform configuration, including project ID, region, resource prefix, and user list.

## Variables

The following variables can be configured in the `terraform.tfvars` file or passed as command-line arguments:

- `project_id`: The ID of the Google Cloud project.
- `region`: The region for the Google Cloud project resources (default: `asia-southeast1`).
- `resource_prefix`: The prefix for shared resources (default: `ai-takeoff`).
- `project_users`: A set of usernames to be granted project roles (default: `[]`).
- `bq_region`: BigQuery slot region (default: `us-central`).
- `vertex_ai_region`: Vertex AI region (default: `us-central1`).
- `alloydb_psa_subnet`: AlloyDB private service access subnet base IP address (default: `10.7.128.0/20`).
- `alloydb_initial_user`: AlloyDB initial user (default: `postgres`).
- `alloydb_initial_password`: AlloyDB initial password (no default, must be provided).

## Outputs

The following outputs will be displayed after applying the Terraform configuration:

- `project_id`: The VPC project ID.
- `vpc_id`: The VPC network ID.
- `vpc_network_name`: The VPC network name.
- `vpc_subnet_ips`: The VPC subnet IPs.
- `project_users`: The list of project users.
- `region`: The configured region.
- `resource_prefix`: The configured resource prefix.
- `random_region`: A randomly selected region.
- `random_zone`: A randomly selected zone.
- `random_zone_list`: A list of randomly selected zones.
- `bq_region`: The configured BigQuery region.
- `vertex_ai_region`: The configured Vertex AI region.
- `alloydb_psa_subnet`: The configured AlloyDB PSA subnet.
- `alloydb_initial_user`: The configured AlloyDB initial user.
- `alloydb_initial_password`: The configured AlloyDB initial password.

## Usage

1.  **Prerequisites:**
    *   Terraform installed.
    *   Google Cloud SDK installed and configured.
    *   A Google Cloud project and billing account.

2.  **Configuration:**
    *   Set the required variables in a `terraform.tfvars` file or through environment variables.
    *   Ensure that the `project_users` variable is set correctly.
    *   Ensure that the `project_id`, `billing_account` and `resource_id` are set correctly.

3.  **Initialization:**
    ```bash
    terraform init
    ```

4.  **Planning:**
    ```bash
    terraform plan
    ```

5.  **Deployment:**
    ```bash
    terraform apply
    ```

6. **Destroy**
    ```bash
    terraform destroy
    ```
