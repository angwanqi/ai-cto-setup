# Instructions for Quota Increase Request
1. Clone this repo into your Cloud Shell
2. Paste all your project IDs into projects.txt
3. Enable Vertex AI and Cloud Quota API -> Open Terminal and run ```bash 0_enable_api.sh```
5. Open ```1_submit_qir.sh``` and input your email in Line 28 ```EMAIL="<UPDATE_EMAIL>"```
6. Open Terminal and run ```bash 1_submit_qir.sh```
7. Once completed, run ```bash 2_extract_traceid.sh```
8. You should see a CSV file created named ```vertex_quota_traceids.csv```
9. Download the CSV file and share it with GCP team
