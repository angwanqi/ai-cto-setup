# Instructions for Quota Increase Request for Vertex AI
These instructions assumes that you have completed the steps listed in the repo's [README.md](../README.md). If you have yet to complete the steps, please complete them before proceeding with the steps below. 

## Submitting quota increase requests in bulk
1. Open ```1_vertex_submit_qir.sh``` and input your email in Line 28 ```EMAIL="<UPDATE_EMAIL>"```
2. In Terminal, run ```bash 1_vertex_submit_qir.sh```
3. Once completed, run ```bash 2_vertex_extract_traceid.sh```
4. You should see a CSV file created named ```vertex_qir_traceids.csv```
5. Download the CSV file and share it with GCP team
6. GCP team will then let you know when to proceed to next section to verify the status of the requests.

## Checking the status of the quota increase requests
1. Ensure that all your project IDs are in ```projects.txt```.
2. In Terminal, run ```bash 3_vertex_check_status.sh```.
3. You should see a CSV file created named ```vertex_qir_status.csv```
4. Download the CSV file and share it with GCP team

