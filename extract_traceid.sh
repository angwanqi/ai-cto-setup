#!/bin/bash

# Create the output file (or overwrite if it exists) with header row
echo "Project ID,Quota ID,Trace ID,Preference ID" > all_quota_info.csv

# Loop through projects (1 to 10)
for i in {1..1}; do
  PROJECT_ID="ai-cto-$i"  # Your project ID naming pattern. Adjust as needed!
  BILLING_PROJECT_ID="$PROJECT_ID" # Or your separate billing project ID

  echo "Processing project: $PROJECT_ID"

  # Construct the resource name dynamically
  RESOURCE_NAME="ai-cto-${i}-gpu"  # Adjust resource name pattern if necessary.

  # Run the gcloud command and capture the output
  output=$(gcloud beta quotas preferences describe "$RESOURCE_NAME" --project="$PROJECT_ID" --billing-project="$BILLING_PROJECT_ID" --format=json 2>/dev/null)

  create_time=$(jq -r '.createTime' <<< "$output")
  region=$(jq -r '.dimensions.region' <<< "$output")
  etag=$(jq -r '.etag' <<< "$output")
  name=$(jq -r '.name' <<< "$output")
  granted_value=$(jq -r '.quotaConfig.grantedValue' <<< "$output")
  preferred_value=$(jq -r '.quotaConfig.preferredValue' <<< "$output")
  quota_id=$(jq -r '.quotaId' <<< "$output")
  service=$(jq -r '.service' <<< "$output")
  update_time=$(jq -r '.updateTime' <<< "$output")
  trace_id=$(jq -r '.quotaConfig.traceId' <<< "$output")

  # Print the extracted values
  echo "createTime: $create_time"
  echo "region: $region"
  echo "etag: $etag"
  echo "name: $name"
  echo "grantedValue: $granted_value"
  echo "preferredValue: $preferred_value"
  echo "quotaId: $quota_id"
  echo "service: $service"
  echo "updateTime: $update_time"
  echo "traceID: $trace_id"

  # Set the output CSV file name
  csv_file="quota_data.csv"

  # Check if the CSV file exists. If not, create it with headers
  if [ ! -f "$csv_file" ]; then
    echo "createTime,region,etag,name,grantedValue,preferredValue,quotaId,service,updateTime,traceID" > "$csv_file"
  fi

  # Append the extracted values to the CSV file
  echo "$create_time,$region,$etag,$name,$granted_value,$preferred_value,$quota_id,$service,$update_time,$trace_id" >> "$csv_file"

  echo "Data appended to $csv_file"





  # # Check if the command was successful (exit code 0)
  # if [[ $? -eq 0 ]]; then
  #   # Extract the information using jq (handle potential errors)
  #   project_id=$(echo "$output" | jq -r '.name | split("/") |' 2>/dev/null)  # Corrected!
  #   quota_id=$(echo "$output" | jq -r '.quotaId' 2>/dev/null)
  #   trace_id=$(echo "$output" | jq -r '.quotaConfig.traceId' 2>/dev/null)
  #   preference_id=$(echo "$output" | jq -r '.name | split("/") |' 2>/dev/null) # Corrected!

  #   # Check if all values were extracted successfully
  #   if [[ -n "$project_id" && -n "$quota_id" && -n "$trace_id" && -n "$preference_id" ]]; then
  #     echo "$project_id,$quota_id,$trace_id,$preference_id" >> all_quota_info.csv  # Append to the file
  #     echo "Quota info for $PROJECT_ID added to file."
  #   else
  #     echo "Error: Could not extract all information for $PROJECT_ID. Check the JSON output:"
  #     echo "$output"
  #   fi
  # else
  #   echo "Error: gcloud command failed for $PROJECT_ID. Check the output:"
  #   echo "$output"
  # fi

  echo "--------------------" # Separator for clarity
done

echo "Script completed. Quota information is in all_quota_info.csv"