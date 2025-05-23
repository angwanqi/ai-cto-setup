#!/bin/bash

# Define the list of services to enable
services=(
  "iam.googleapis.com"
  "orgpolicy.googleapis.com"
  "compute.googleapis.com"
  "servicenetworking.googleapis.com"
  "notebooks.googleapis.com"
  "cloudresourcemanager.googleapis.com"
  "aiplatform.googleapis.com"
  "pubsub.googleapis.com"
  "run.googleapis.com"
  "cloudbuild.googleapis.com"
  "dataflow.googleapis.com"
  "bigquery.googleapis.com"
  "artifactregistry.googleapis.com"
  "language.googleapis.com"
  "documentai.googleapis.com"
  "storage.googleapis.com"
  "discoveryengine.googleapis.com"
  "cloudbilling.googleapis.com"
  "secretmanager.googleapis.com"
  "monitoring.googleapis.com"
  "cloudtrace.googleapis.com"
)

# Loop through all project IDs from projects.txt
# TODO: Ensure that you have filled up projects.txt with all your project IDs
for proj in $(cat projects.txt); do
  PROJECT_ID="$proj"

  # Check if the project ID is valid (optional but recommended)
  if [[ ! "$PROJECT_ID" =~ ^[a-z][a-z0-9-]*[a-z0-9]$ ]]; then
    echo "Invalid project ID format: $PROJECT_ID. Skipping."
    echo "--------------------" # Separator for clarity
    continue  # Skip to the next iteration
  fi

  echo "Attempting to enable services for project: $PROJECT_ID"

  # Set the project for gcloud commands
#   gcloud config set project "$PROJECT_ID"

  # Loop through each service and attempt to enable it
  for service_name in "${services[@]}"; do
    echo "  Enabling service: $service_name"

    # Attempt to activate the service. Capture output and exit code
    output=$(gcloud services enable "$service_name" --project "$PROJECT_ID" 2>&1)
    exit_code=$?

    # Check the result for each service
    if [[ $exit_code -eq 0 ]]; then
      echo "    Service $service_name enabled successfully."
    elif [[ "$output" == *"PERMISSION_DENIED"* ]]; then
      echo "    ERROR: PERMISSION_DENIED for $service_name in project $PROJECT_ID. Ensure you have the necessary permissions. Output: $output"
    elif [[ "$output" == *"already enabled"* ]]; then
      echo "    Service $service_name is already enabled. Skipping."
    else
      echo "    ERROR: Failed to enable $service_name for project $PROJECT_ID. Output: $output"
    fi
  done

  echo "Finished processing project: $PROJECT_ID"
  echo "--------------------" # Separator between projects

done

echo "Script completed."