variable "project_id" {
  type        = string
  description = "The ID of the Google Cloud project"
}

variable "region" {
  type        = string
  description = "The region for the Google Cloud project resources"
  default     = "asia-southeast1" # Set a default region
}

variable "resource_prefix" {
  type        = string
  description = "The default ID for shared resources"
  default     = "ai-takeoff"
}

variable "project_users" {
  type        = set(string)
  description = "A set of usernames to be granted the project roles"
  default     = [] # Set an empty set as default
}

variable "override_external_ip_policy" {
  type        = bool
  description = "Override policy to allow external ip for project"
  default     = false
}

## lab specific variables ########################################################################

# BigQuery ######
variable "bq_region" {
  type        = string
  description = "BigQuery slot region"
  default     = "us-central" # Please use values: "us-centra11" or "us"
}

# Vertex AI #####
variable "vertex_ai_region" {
  type        = string
  description = "Vertex AI region"
  default     = "us-central1"
}

# AlloyDB #######
variable "alloydb_psa_subnet" {
  type        = string
  description = "AlloyDB private service access subnet base IP address"
  default     = "10.7.128.0/20"
}

variable "alloydb_initial_user" {
  type        = string
  description = "AlloyDB initial user"
  default     = "postgres"
}

variable "alloydb_initial_password" {
  type        = string
  description = "AlloyDB initial password"
}
