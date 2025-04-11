# Instructions for Quota Increase Request for Cloud Run
1. Paste all your project IDs into [projects.txt](../projects.txt)
2. Run [0_enable_api.sh](../0_enable_api.sh) to enable Cloud Run API in all projects
3. Open ```1_submit_cloudrun_qir.sh``` and input your email in Line 28 ```EMAIL="<UPDATE_EMAIL>"```
4. Open Terminal and run ```bash 1_submit_cloudrun_qir.sh```
5. Once completed, run ```bash 2_extract_cloudrun_traceid.sh```
6. You should see a CSV file created named ```cloudrun_quota_data.csv```
7. Download the CSV file and share it with GCP team
