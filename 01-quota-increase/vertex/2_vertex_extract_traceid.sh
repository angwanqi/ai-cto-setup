#!/bin/bash

# Sample output
# createTime: '2025-02-10T12:32:04.507545766Z'
# dimensions:
#   region: us-east4
# etag: 2oRpbz2XdILXC_4JyoIpuPtN4r4gxLa_YjJ4RSAr_mQ
# name: projects/ai-cto-1/locations/global/quotaPreferences/a100-80gb-serving-ai-cto-1-us-east4
# quotaConfig:
#   grantedValue: '0'
#   preferredValue: '1'
#   traceId: e9ca473c85474d3495
# quotaId: CustomModelServingA10080GBGPUsPerProjectPerRegion
# reconciling: true
# service: aiplatform.googleapis.com
# updateTime: '2025-02-10T12:32:07.460787652Z'

REGIONS=("us-central1" "europe-west4" "asia-southeast1")

# Loop through all projects
# TODO: Ensure that you have filled up projects.txt with all your project IDs
for proj in $(cat projects.txt); do
  PROJECT_ID="$proj"
  BILLING_PROJECT_ID="$PROJECT_ID"

  echo "Processing project: $PROJECT_ID"

  # Construct the resource name dynamically
  for REGION in "${REGIONS[@]}"; do

    # PREFERENCE_ID for Serving
    PREFERENCE_ID="a100-80gb-serving-${PROJECT_ID}-${REGION}"

    # Run the gcloud command and capture the output
    output=$(gcloud beta quotas preferences describe "$PREFERENCE_ID" --project="$PROJECT_ID" --billing-project="$BILLING_PROJECT_ID" --format=json 2>/dev/null)

    region=$(jq -r '.dimensions.region' <<< "$output")
    name=$(jq -r '.name' <<< "$output")
    preferred_value=$(jq -r '.quotaConfig.preferredValue' <<< "$output")
    quota_id=$(jq -r '.quotaId' <<< "$output")
    trace_id=$(jq -r '.quotaConfig.traceId' <<< "$output")

    # Set the output CSV file name
    csv_file="vertex_qir_traceids.csv"

    # Check if the CSV file exists. If not, create it with headers
    if [ ! -f "$csv_file" ]; then
      echo "projectId,quotaId,region,traceID,preferredValue,name" > "$csv_file"
    fi

    # Append the extracted values to the CSV file
    echo "$PROJECT_ID,$quota_id,$region,$trace_id,$preferred_value,$name" >> "$csv_file"

    echo "Data appended to $csv_file - ${PROJECT_ID} ${REGION} ${quota_id} "
    echo "" # Separator for clarity

    # PREFERENCE_ID for Training
    PREFERENCE_ID="a100-80gb-training-${PROJECT_ID}-${REGION}"
    
    # Run the gcloud command and capture the output
    output=$(gcloud beta quotas preferences describe "$PREFERENCE_ID" --project="$PROJECT_ID" --billing-project="$BILLING_PROJECT_ID" --format=json 2>/dev/null)

    region=$(jq -r '.dimensions.region' <<< "$output")
    name=$(jq -r '.name' <<< "$output")
    preferred_value=$(jq -r '.quotaConfig.preferredValue' <<< "$output")
    quota_id=$(jq -r '.quotaId' <<< "$output")
    trace_id=$(jq -r '.quotaConfig.traceId' <<< "$output")

    # Append the extracted values to the CSV file
    echo "$PROJECT_ID,$quota_id,$region,$trace_id,$preferred_value,$name" >> "$csv_file"

    echo "Data appended to $csv_file - ${PROJECT_ID} ${REGION} ${quota_id} "
    echo "--------------------" # Separator for clarity

  done
done

echo "Script completed. Quota information is in ${csv_file}"
