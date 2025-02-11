#!/bin/bash

# Define the regions you want to loop through
REGIONS=("us-central1" "europe-west4" "asia-southeast1") # Add more regions as needed

# Loop through projects 1 to 2 (as you specified)
for i in {1..1}; do
  PROJECT_ID="ai-cto-$i"

  # Check if the project ID is valid (optional but recommended)
  if [[ ! "$PROJECT_ID" =~ ^[a-z][a-z0-9-]*[a-z0-9]$ ]]; then
    echo "Invalid project ID format: $PROJECT_ID. Skipping."
    continue
  fi

  # Loop through each region
  for REGION in "${REGIONS[@]}"; do

    # REQUEST FOR VERTEX SERVING 
    QUOTA_ID="CustomModelServingA10080GBGPUsPerProjectPerRegion"
    echo "Requesting quota increase for project: $PROJECT_ID, region: $REGION, quota: $QUOTA_ID"

    SERVICE_NAME="aiplatform.googleapis.com"
    PREFERRED_VALUE=1
    DIMENSIONS="region=$REGION"
    JUSTIFICATION="Requesting A100 80GB GPU quota for OSS LLM test."
    EMAIL="<UPDATE_EMAIL>"
    PREFERENCE_ID="a100-80gb-serving-$PROJECT_ID-$REGION"

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
        --format="json" 2>&1)

    exit_code=$?

    if [[ $exit_code -eq 0 ]]; then
      echo "Quota preference request submitted successfully for project: $PROJECT_ID, region: $REGION, quota: $QUOTA_ID"
    elif [[ "$output" == *"PERMISSION_DENIED"* ]]; then
      echo "Error: Permission denied while requesting quota preference for project $PROJECT_ID, region $REGION, quota: $QUOTA_ID. Ensure you have the 'Compute Quota Admin' role."
    else
      echo "Error requesting quota preference for project: $PROJECT_ID, region: $REGION: $output, quota: $QUOTA_ID"
    fi

    echo "--------------------"

    # REQUEST FOR VERTEX TRAINING
    QUOTA_ID="CustomModelTrainingA10080GBGPUsPerProjectPerRegion"
    echo "Requesting quota increase for project: $PROJECT_ID, region: $REGION, quota: $QUOTA_ID"
    
    PREFERENCE_ID="a100-80gb-training-$PROJECT_ID-$REGION"

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
        --format="json" 2>&1)

    exit_code=$?

    if [[ $exit_code -eq 0 ]]; then
      echo "Quota preference request submitted successfully for project: $PROJECT_ID, region: $REGION, quota: $QUOTA_ID"
    elif [[ "$output" == *"PERMISSION_DENIED"* ]]; then
      echo "Error: Permission denied while requesting quota preference for project $PROJECT_ID, region $REGION, quota: $QUOTA_ID. Ensure you have the 'Compute Quota Admin' role."
    else
      echo "Error requesting quota preference for project: $PROJECT_ID, region: $REGION, quota: $QUOTA_ID: $output"
    fi

    echo "--------------------"

  done # End of region loop

done # End of project loop

echo "Script completed."