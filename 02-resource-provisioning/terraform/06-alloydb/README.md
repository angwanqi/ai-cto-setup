# AlloyDB Terraform Module

This Terraform module provisions an AlloyDB cluster and instances on Google Cloud Platform (GCP).

## Prerequisites

- Terraform installed
- Google Cloud SDK installed and configured
- Appropriate GCP permissions to create resources

## Usage

1.  **Initialize Terraform:**

    ```bash
    terraform init
    ```

2.  **Plan the changes:**

    ```bash
    terraform plan
    ```

3.  **Apply the changes:**

    ```bash
    terraform apply
    ```

## Variables

The following variables are inherited from the `01-base-infra` module's terraform state.  See that module's documentation for details.  These include:

    *   `project_id`: The GCP project ID.
    *   `region`: The GCP region.
    *   `vpc_id`: The VPC network ID.
    *   `vpc_network_name`: The VPC network name.
    *   `vpc_subnet_ips`: A list of subnet IP ranges in the VPC.
    *   `resource_prefix`: A prefix for resource names.
    *   `project_users`: A list of project users who will be granted access to the AlloyDB cluster via IAM.
    *   `alloydb_psa_subnet`: The IP range for the private service access subnet used by AlloyDB.
    *   `alloydb_initial_user`: The initial user for the AlloyDB cluster (defaults to "postgres").

## Resources Created

The module creates the following resources:

-   **Google Project Services:** Enables the necessary GCP APIs for AlloyDB, Compute Engine, IAM, and networking.
-   **Compute Global Address:** Allocates a private IP range for AlloyDB's private service access.
-   **Service Networking Connection:** Creates a private service connection between the VPC and AlloyDB.
-   **Compute Network Peering Routes Config:** Configures custom route importing and exporting for the VPC peering.
-   **AlloyDB Cluster:** Creates an AlloyDB cluster with the specified configuration, including initial user, network settings, and backup policies.  Creates 3 clusters.
-   **AlloyDB Instance:** Creates primary instances within the AlloyDB cluster. Creates 3 primary instances, one in each cluster.
-   **AlloyDB Instance (Read Pool):** Creates read pool instances for the AlloyDB cluster. Creates 3 read pool instances, one in each cluster.
-   **Compute Firewall:** Creates a firewall rule to allow traffic to AlloyDB instances from within the VPC on port 5432.
-   **AlloyDB User:** Creates IAM users for project members to access the AlloyDB cluster. Creates 3 users, one for each user defined in the `project_users` variable.
-   **Project IAM Binding:** Grants the `roles/aiplatform.user` role to the AlloyDB service account.

## Notes

-   This module uses the `google-beta` provider for AlloyDB resources, as AlloyDB is still in beta.
-   The module assumes that a base infrastructure module has already been provisioned, providing necessary network and project information.
-   The AlloyDB cluster is configured with continuous backup enabled and automated backups disabled.
-   The firewall rule allows access from all subnets within the VPC. You may need to adjust this based on your security requirements.
-   The module creates 3 clusters and 3 primary and 3 read pool instances. You can adjust the `count` parameter on the `google_alloydb_cluster`, `google_alloydb_instance` and `google_alloydb_instance` resources to change this.

## Troubleshooting

-   **API Errors:** Ensure that all required APIs are enabled in your GCP project.
-   **Networking Issues:** Verify that the VPC network and subnet configurations are correct and that there are no conflicting firewall rules.
-   **Permission Errors:** Ensure that the Terraform service account has the necessary permissions to create and manage AlloyDB resources.
-   **State Conflicts:** If you encounter state conflicts, try running `terraform refresh` or manually updating the Terraform state.

## Cleanup

To destroy the resources created by this module, run:

```bash
terraform destroy
```

**Important:** This will permanently delete all AlloyDB clusters and instances.