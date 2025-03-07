# Instructions for Quota Increase Request for Cloud Run
1. Paste all your project IDs into [projects.txt](../projects.txt)
2. Open ```1_submit_cloudrun_qir.sh``` and input your email in Line 28 ```EMAIL="<UPDATE_EMAIL>"```
3. Open Terminal and run ```bash 1_submit_cloudrun_qir.sh```
4. Once completed, run ```bash 2_extract_cloudrun_traceid.sh```
5. You should see a CSV file created named ```cloudrun_quota_data.csv```
6. Download the CSV file and share it with GCP team
