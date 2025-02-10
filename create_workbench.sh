export PROJECT_ID=$(gcloud config get-value project)

for i in $(seq 2 3); do 
  gcloud workbench instances create ai-takeoff-$i \
      --location="us-central1-a" \
      --project="$PROJECT_ID" \
      --machine-type="e2-standard-8" \
      --labels="env=dev,type=workbench" \
      --data-disk-size="330" \
      --data-disk-type="PD_BALANCED" \
      --metadata="shutdown-script=\"\"" 
done