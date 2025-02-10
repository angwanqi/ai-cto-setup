#!/bin/bash

# Loop through projects 1 to 2 (as you specified)
for i in {2..2}; do
  PROJECT_ID="ai-cto-$i"  # Replace with your actual project ID format

  # Check if the project ID is valid (optional but recommended)
  if [[ ! "$PROJECT_ID" =~ ^[a-z][a-z0-9-]*[a-z0-9]$ ]]; then
    echo "Invalid project ID format: $PROJECT_ID. Skipping."
    continue  # Skip to the next iteration
  fi

  # Set the region to us-central1 ONLY
  REGION="asia-southeast1"

  # REQUEST FOR VERTEX SERVING 
  QUOTA_ID="CustomModelServingA10080GBGPUsPerProjectPerRegion" # The quota ID. CRITICAL. Verify!

  echo "Requesting quota increase for project: $PROJECT_ID, region: $REGION, quota: $QUOTA_ID"

  SERVICE_NAME="aiplatform.googleapis.com"  # The service name. Verify!
  PREFERRED_VALUE=7 # The desired limit. Change this!
  DIMENSIONS="region=$REGION" # Region dimension. Essential.
  JUSTIFICATION="Requesting A100 80GB GPU quota for OSS LLM test." # Be specific!
  EMAIL="bruce@wqang.altostrat.com"  # Your email address for updates.
  PREFERENCE_ID="a100-80gb-serving-$PROJECT_ID-$REGION" # Unique ID for each request

  # Submit the quota preference request
  output=$(gcloud beta quotas preferences create \
      --preferred-value="$PREFERRED_VALUE" \
      --quota-id="$QUOTA_ID" \
      --service="$SERVICE_NAME" \
      --project="$PROJECT_ID" \
      --dimensions="$DIMENSIONS" \
      --billing-project="$PROJECT_ID" \
      --justification="$JUSTIFICATION" \
      --email="$EMAIL" \
      --preference-id="$PREFERENCE_ID" \
      --format="json" 2>&1) # Add --format=json for easier parsing

  exit_code=$?

  if [[ $exit_code -eq 0 ]]; then
    echo "Quota preference request submitted successfully for project: $PROJECT_ID, region: $REGION, quota: $QUOTA_ID"

    # Extract information and write to file (see below)

  elif [[ "$output" == *"PERMISSION_DENIED"* ]]; then
    echo "Error: Permission denied while requesting quota preference for project $PROJECT_ID, region $REGION, quota: $QUOTA_ID. Ensure you have the 'Compute Quota Admin' role."
  else
    echo "Error requesting quota preference for project: $PROJECT_ID, region: $REGION: $output, quota: $QUOTA_ID"
  fi

  echo "--------------------"

  # REQUEST FOR VERTEX TRAINING
  QUOTA_ID="CustomModelTrainingA10080GBGPUsPerProjectPerRegion" # The quota ID. CRITICAL. Verify!

  echo "Requesting quota increase for project: $PROJECT_ID, region: $REGION, quota: $QUOTA_ID"
  
  JUSTIFICATION="Requesting A100 80GB GPU quota for OSS LLM test." # Be specific!
  EMAIL="bruce@wqang.altostrat.com"  # Your email address for updates.
  PREFERENCE_ID="a100-80gb-training-$PROJECT_ID-$REGION" # Unique ID for each request

  # Submit the quota preference request
  output=$(gcloud beta quotas preferences create \
      --preferred-value="$PREFERRED_VALUE" \
      --quota-id="$QUOTA_ID" \
      --service="$SERVICE_NAME" \
      --project="$PROJECT_ID" \
      --dimensions="$DIMENSIONS" \
      --billing-project="$PROJECT_ID" \
      --justification="$JUSTIFICATION" \
      --email="$EMAIL" \
      --preference-id="$PREFERENCE_ID" \
      --format="json" 2>&1) # Add --format=json for easier parsing

  exit_code=$?

  if [[ $exit_code -eq 0 ]]; then
    echo "Quota preference request submitted successfully for project: $PROJECT_ID, region: $REGION, quota: $QUOTA_ID"

    # Extract information and write to file (see below)

  elif [[ "$output" == *"PERMISSION_DENIED"* ]]; then
    echo "Error: Permission denied while requesting quota preference for project $PROJECT_ID, region $REGION, quota: $QUOTA_ID. Ensure you have the 'Compute Quota Admin' role."
  else
    echo "Error requesting quota preference for project: $PROJECT_ID, region: $REGION, quota: $QUOTA_ID: $output"
  fi

  echo "--------------------"

done

echo "Script completed."