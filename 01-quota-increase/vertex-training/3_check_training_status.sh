#!/bin/bash

# Sample output
# createTime: '2025-02-03T16:17:45.019330920Z'
# dimensions:
#   region: us-central1
# etag: npuxYyTOQZUxpyfOKgkN1sOoO1jSiT7hcr0QoDiQ9G8
# name: projects/ai-cto-1/locations/global/quotaPreferences/a100-80gb-training-ai-cto-1-us-central1
# quotaConfig:
#   grantedValue: '4'
#   preferredValue: '4'
#   traceId: c99ac496cacb43f6af
# quotaId: CustomModelTrainingA10080GBGPUsPerProjectPerRegion
# service: aiplatform.googleapis.com
# updateTime: '2025-02-03T16:17:48.697712242Z'

REGIONS=("asia-southeast1")

# Loop through all projects
# TODO: Ensure that you have filled up projects.txt with all your project IDs
for proj in $(cat ../projects.txt); do
  PROJECT_ID="$proj"
  BILLING_PROJECT_ID="$PROJECT_ID" # Or your separate billing project ID

  for REGION in "${REGIONS[@]}"; do

    echo "Processing project: $PROJECT_ID for $REGION."

    # PREFERENCE_ID for Training
    PREFERENCE_ID="a100-80gb-training-v2-${PROJECT_ID}-${REGION}"

    # Run the gcloud command and capture the output
    output=$(gcloud beta quotas preferences describe "$PREFERENCE_ID" --project="$PROJECT_ID" --billing-project="$BILLING_PROJECT_ID" --format=json 2>/dev/null)

    region=$(jq -r '.dimensions.region' <<< "$output")
    name=$(jq -r '.name' <<< "$output")
    granted_value=$(jq -r '.quotaConfig.grantedValue' <<< "$output")
    preferred_value=$(jq -r '.quotaConfig.preferredValue' <<< "$output")
    quota_id=$(jq -r '.quotaId' <<< "$output")
    trace_id=$(jq -r '.quotaConfig.traceId' <<< "$output")

    # Check if grantedValue equals preferredValue
    if [ "$granted_value" = "$preferred_value" ]; then
      match="true"
    else
      match="false"
    fi

    # Set the output CSV file name
    csv_file="vertex_qir_status.csv"

    # Check if the CSV file exists. If not, create it with headers
    if [ ! -f "$csv_file" ]; then
      echo "projectId,quotaId,region,traceID,preferredValue,grantedValue,match,name" > "$csv_file"
    fi

    # Append the extracted values to the CSV file
    echo "$PROJECT_ID,$quota_id,$region,$trace_id,$preferred_value,$granted_value,$match,$name" >> "$csv_file"

    echo "Data appended to $csv_file - ${PROJECT_ID} ${REGION} ${quota_id} "
    echo "--------------------"

  done
done

echo "Script completed. Quota information is in ${csv_file}"
