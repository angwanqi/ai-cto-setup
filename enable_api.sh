#!/bin/bash

# Loop through projects 1 to 10 (replace 10 with your actual number of projects)
for i in {1..10}; do
  PROJECT_ID="ai-cto-$i"  # Replace with your actual project ID format

  # Check if the project ID is valid (optional but recommended)
  if [[ ! "$PROJECT_ID" =~ ^[a-z][a-z0-9-]*[a-z0-9]$ ]]; then
    echo "Invalid project ID format: $PROJECT_ID. Skipping."
    continue  # Skip to the next iteration
  fi

  # ENABLE VERTEX AI API
  echo "Enabling AI Platform API for project: $PROJECT_ID"

  # Attempt to activate the service.  Capture output and exit code
  output=$(gcloud services enable aiplatform.googleapis.com --project="$PROJECT_ID" 2>&1)
  exit_code=$?

  # Check the result
  if [[ $exit_code -eq 0 ]]; then
    echo "AI Platform API enabled successfully for project: $PROJECT_ID"
  elif [[ "$output" == *"PERMISSION_DENIED"* ]]; then  # Check for permissions issue
      echo "Error: Permission denied while enabling API for project $PROJECT_ID.  Please ensure you have the necessary IAM roles (e.g., Service Account Token Creator or Project Editor) for this project."
  elif [[ "$output" == *"ALREADY_ENABLED"* ]]; then # Check if already enabled
      echo "AI Platform API is already enabled for project: $PROJECT_ID"
  else
    echo "Error enabling AI Platform API for project: $PROJECT_ID: $output"
  fi

  echo "--------------------" # Separator between projects


  # ENABLE CLOUD QUOTAS API
  echo "Enabling Cloud Quotas API for project: $PROJECT_ID"

  # Attempt to activate the service.  Capture output and exit code
  output=$(gcloud services enable cloudquotas.googleapis.com --project="$PROJECT_ID" 2>&1)
  exit_code=$?

  # Check the result
  if [[ $exit_code -eq 0 ]]; then
    echo "Cloud Quotas API enabled successfully for project: $PROJECT_ID"
  elif [[ "$output" == *"PERMISSION_DENIED"* ]]; then  # Check for permissions issue
      echo "Error: Permission denied while enabling API for project $PROJECT_ID.  Please ensure you have the necessary IAM roles (e.g., Service Account Token Creator or Project Editor) for this project."
  elif [[ "$output" == *"ALREADY_ENABLED"* ]]; then # Check if already enabled
      echo "Cloud Quotas API is already enabled for project: $PROJECT_ID"
  else
    echo "Error enabling Cloud Quotas API for project: $PROJECT_ID: $output"
  fi

  echo "--------------------" # Separator between projects

done

echo "Script completed."