# Lab specific variables

# # AlloyDB
# variable "alloydb_psa_subnet" {
#   type        = string
#   description = "AlloyDB private service access subnet base IP address"
#   default     = "10.7.128.0/20"
# }

# variable "alloydb_initial_user" {
#   type        = string
#   description = "AlloyDB initial user"
#   default     = "postgres"
# }

# variable "alloydb_initial_password" {
#   type        = string
#   description = "AlloyDB initial password"
# }

variable "enable_readpool" {
  type        = bool
  description = "Whether to enable read pool (default: false)"
  default     = false # set to true to enable read pool
}

# variable "secondary_region" {
#   type        = string
#   description = "Region for secondary cluster"
#   default     = "us-central1"
# }