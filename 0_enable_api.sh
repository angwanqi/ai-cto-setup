#!/bin/bash

# Loop through all projects
# TODO: Ensure that you have filled up projects.txt with all your project IDs
for proj in $(cat projects.txt); do
  PROJECT_ID="$proj"

  # Check if the project ID is valid (optional but recommended)
  if [[ ! "$PROJECT_ID" =~ ^[a-z][a-z0-9-]*[a-z0-9]$ ]]; then
    echo "Invalid project ID format: $PROJECT_ID. Skipping."
    continue  # Skip to the next iteration
  fi

  # ENABLE VERTEX AI API
  echo "Enabling Vertex AI API for project: $PROJECT_ID"

  # Attempt to activate the service.  Capture output and exit code
  output=$(gcloud services enable aiplatform.googleapis.com --project="$PROJECT_ID" 2>&1)
  exit_code=$?

  # Check the result
  if [[ $exit_code -eq 0 ]]; then
    echo "Vertex AI API enabled successfully for project: $PROJECT_ID"
  elif [[ "$output" == *"PERMISSION_DENIED"* ]]; then  # Check for permissions issue
      echo "Error enabling AI Platform API for project: $PROJECT_ID: $output"
  else
    echo "Error enabling AI Platform API for project: $PROJECT_ID: $output"
  fi

  # ENABLE CLOUD QUOTAS API
  echo "Enabling Cloud Quotas API for project: $PROJECT_ID"

  # Attempt to activate the service.  Capture output and exit code
  output=$(gcloud services enable cloudquotas.googleapis.com --project="$PROJECT_ID" 2>&1)
  exit_code=$?

  # Check the result
  if [[ $exit_code -eq 0 ]]; then
    echo "Cloud Quotas API enabled successfully for project: $PROJECT_ID"
  elif [[ "$output" == *"PERMISSION_DENIED"* ]]; then  # Check for permissions issue
      echo "Error: Permission denied while enabling API for project $PROJECT_ID: $output"
  else
    echo "Error enabling Cloud Quotas API for project: $PROJECT_ID: $output"
  fi

  echo "--------------------" # Separator between projects

done

echo "Script completed."