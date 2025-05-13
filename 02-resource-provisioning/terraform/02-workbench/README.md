
## Components

### `main.tf`

This file defines the core logic for creating the Vertex AI Workbench instances.

#### Data Sources

-   **`terraform_remote_state` (base_infra):** Retrieves outputs from the `01-base-infra` module, including:
    -   `project_id`: The ID of the Google Cloud project.
    -   `region`: The region where resources are deployed.
    -   `vpc_id`: The ID of the VPC network.
    - `random_region`: a random region
    - `random_zone_list`: a list of random zones
    -   `resource_prefix`: A prefix for naming resources.
    -   `project_users`: A list of users who will be granted access to the project.

#### Locals

-   Defines local variables derived from the `base_infra` outputs, making them easier to reference throughout the configuration.
- `lab_services`: a list of services to be enabled. Currently empty.

#### Resources

-   **`google_project_service` (lab_services):** Enables specified Google Cloud APIs. Currently, no APIs are enabled, but this resource is ready to be used if needed.
-   **`google_workbench_instance` (default):** Creates three Vertex AI Workbench instances.
    -   **`name`:** The name of each instance is dynamically generated using the `resource_prefix` and an index.
    -   **`location`:** The location is set to a region and a random zone from the `random_zone_list` output.
    -   **`project`:** The Google Cloud project ID.
    -   **`instance_owners`:** The owners of the instance are set to the users from the `project_users` list.
    -   **`gce_setup`:** Configures the underlying Compute Engine instance:
        -   **`machine_type`:** `e2-standard-8`.
        -   **`disable_public_ip`:** Set to `true` for security.
        -   **`boot_disk`:** 150 GB PD-Balanced disk.
        -   **`data_disks`:** 100 GB PD-Balanced disk.
        -   **`shielded_instance_config`:** Enables secure boot, integrity monitoring, and vTPM.
        -   **`network_interfaces`:** Connects the instance to the specified VPC and subnet.

### `variables.tf`

-   This file is currently commented out, but it's intended to define input variables for the module.
-   It can be uncommented and populated to allow for customization of the module's behavior.

## Usage

1.  **Initialize Terraform:**
    ```bash
    terraform init
    ```

2.  **Plan:**
    ```bash
    terraform plan
    ```

3.  **Apply:**
    ```bash
    terraform apply
    ```

4. **Destroy**
    ```bash
    terraform destroy
    ```

