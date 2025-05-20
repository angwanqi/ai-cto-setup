# Instructions for Quota Increase Request for Vertex Training
1. Paste all your project IDs into [projects.txt](../projects.txt)
2. Open ```1_submit_training_qir.sh``` and input your email in Line 28 ```EMAIL="<UPDATE_EMAIL>"```
4. Open Terminal and run ```bash 1_submit_training_qir.sh```
5. Once completed, run ```bash 2_extract_training_traceid.sh```
6. You should see a CSV file created named ```vertex_quota_traceids.csv```
7. Download the CSV file and share it with GCP team
