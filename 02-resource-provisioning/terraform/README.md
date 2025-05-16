# Terraform Resource Provisioning

This directory contains Terraform configurations and scripts for provisioning cloud resources. It's designed to help you set up and manage your infrastructure in a structured and modular way.

## Contents

The `terraform/` directory is organized as follows:

*   **`modules/`**: This directory contains reusable Terraform modules. Each module encapsulates a specific piece of infrastructure, making it easy to reuse and manage.
    *   **`bqlab/`**: Contains the Terraform module for setting up BigQuery resources.
    *   **`tenant/`**: Contains the Terraform module for setting up tenant-specific resources.
        *   **`alloy-db/`**: Contains the Terraform module for setting up AlloyDB clusters and instances.
        *   **`firewall-rules/`**: Contains the Terraform module for setting up firewall rules.
        *   **`routes/`**: Contains the Terraform module for setting up routes.
        *   **`subnets/`**: Contains the Terraform module for setting up subnets.
        *   **`vpc/`**: Contains the Terraform module for setting up VPC networks.
*   **`provision.sh`**: A script to provision the resources defined in the Terraform configurations.
*   **`tear-down.sh`**: A script to destroy the resources provisioned by the Terraform configurations.
*   **`01-base-infra`**: Contains the base infrastructure configurations.
*   **`02-workbench`**: Contains the Vertex AI Workbench and related configurations.
*   **`03-bigquery`**: Contains the BigQuery and related configurations.
*   **`04-vertex-training`**: Contains the Vertex AI Training and related configurations.
*   **`05-vertex-serving`**: Contains the Vertex AI Prediction and related configurations.
*   **`06-alloydb`**: Contains the AlloyDB and related configurations.

## Usage

### Prerequisites

*   Terraform installed
*   Google Cloud SDK installed and configured
*   `jq` installed to parse JSON output from `gcloud` commands
*   Appropriate permissions to create and manage resources in your Google Cloud project

Not required, but recommended
*   `tmux` or `screen` when working with remote sessions.

### Provisioning Resources

1.  **Navigate to the Project Directory:**

    ```bash
    cd ~/usr/local/google/home/bookian/Workspaces/ai-cto-setup/02-resource-provisioning/project-1
    ```

2.  **Provide the customer/project specific variables:**

    Create a `.tfvars` file in the `01-base-infra` sub-directory and provide the required variables.

3.  **Run the `provision.sh` script:**

    ```bash
    ./provision.sh
    ```

    This script will initialize Terraform, create a plan, and apply the plan to provision the resources.

### Tearing Down Resources

1.  **Navigate to the Project Directory:**

    ```bash
    cd /usr/local/google/home/bookian/Workspaces/ai-cto-setup/02-resource-provisioning/project-1/01-base-infra
    ```

2.  **Run the `tear-down.sh` script:**

    ```bash
    ./tear-down.sh
    ```

    This script will destroy all the resources that were provisioned by the Terraform configurations.