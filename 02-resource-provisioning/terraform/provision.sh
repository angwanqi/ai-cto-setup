#!/usr/bin/env bash

## you should not have to change anything from this point...
SCRIPT_DIR=$(pwd)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="${SCRIPT_DIR}/terraform_provision_${TIMESTAMP}.log"

# this script requires `gcloud` and `jq` to be present
[ -x "gcloud" ] && echo "Command 'gcloud' not found" >&2 && exit 1
[ -x "jq" ] && echo "Command 'jq' not found" >&2 && exit 1

# Function to log messages
log_message() {
  echo "$(date +'%Y-%m-%d %H:%M:%S'): $1" 2>&1 | tee -a "${LOG_FILE}"
}

# the other modules can proceed in parallel.
declare -a modules=("01-base-infra" "02-workbench" "03-bigquery" "04-vertex-training" "05-vertex-serving" "06-alloydb")

for module_dir in "${modules[@]}"; do
  log_message "Processing module: $module_dir"

  # Navigate into the module directory
  cd "$module_dir" || {
    log_message "Error: Could not change directory to $module_dir"
    continue
  }

  log_message "Running terraform init in $module_dir"
  terraform init -no-color >>"${LOG_FILE}" 2>&1
  if [ $? -ne 0 ]; then
    log_message "Error: terraform init failed in ${module_dir}. Check ${LOG_FILE} for details."
    cd ..
    continue
  fi

  log_message "Running terraform apply -auto-approve in $module_dir"

  # Check if a file was found
  first_tfvars_file=$(find . -maxdepth 1 -name "*.tfvars" -print | head -z -n 1)
  if [ -n "${first_tfvars_file}" ]; then
    log_message "Provisioning using variable file ${first_tfvars_file}"
    VAR_FILE="-var-file=${first_tfvars_file}"
  else
    VAR_FILE=""
  fi

  terraform apply --auto-approve -no-color ${VAR_FILE} >>"${LOG_FILE}" 2>&1
  if [ $? -ne 0 ]; then
    log_message "Error: terraform apply failed in ${module_dir}. Check ${LOG_FILE} for details."
  else
    log_message "Successfully provisioned resources in ${module_dir}"
  fi

  # Navigate back to the base directory
  cd ..
done
