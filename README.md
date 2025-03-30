# Log Archival Pipeline

This repository contains a solution for automating the archival of log files from EC2 instances to Amazon S3. The pipeline archives logs daily, compresses them, and uploads them to a versioned S3 bucket. The pipeline ensures that logs are securely uploaded, organized by date, and properly versioned in the S3 bucket.

## **Overview**

The goal of this project is to create a simple and automated log archival pipeline that:
- Simulates the creation of log files on an EC2 instance.
- Compresses log files and uploads them to a versioned Amazon S3 bucket on a daily basis.
- Ensures that only authorized EC2 instances can upload logs, using IAM roles instead of access keys.
- Organizes logs by date (e.g., `/logs/YYYY-MM-DD/app.log`) in the S3 bucket.

## **Prerequisites**

Before setting up the log archival pipeline, make sure you have:
- AWS Account
- IAM Role with the necessary S3 permissions
- EC2 instance (Amazon Linux 2) with AWS CLI installed
- A bucket in Amazon S3 with versioning enabled

## **Getting Started**

### 1. **Clone the repository**

To clone the repository to your local machine, use the following command:

```bash
git clone https://github.com/Varshith1715/log-archival-pipeline.git
```

### 2. Configure IAM Role
Create an IAM role that allows EC2 instances to interact with the S3 bucket.

![Image](https://github.com/user-attachments/assets/f67c0b6e-8de8-46a8-851f-53a1a6973f1f)

Attach the following policy to the EC2 instance role:

```json

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::my-bucket-var",
                "arn:aws:s3:::my-bucket-var/*"
            ]
        }
    ]
}
```
### 3. Launch EC2 Instance
Launch an EC2 instance using Amazon Linux 2.
![Image](https://github.com/user-attachments/assets/7bfea8d6-1a37-4ee0-a246-045be2ba717f)

![Image](https://github.com/user-attachments/assets/4ea3196b-42aa-43ef-88b3-d4c288b64e12)

Attach the IAM role to the EC2 instance.

![Image](https://github.com/user-attachments/assets/b9557bae-70f8-448c-b2cb-175b74cc1274)

Secure the instance by allowing SSH access only from your IP.

### 4. Simulate Logs
The log simulation script (simulate_logs.sh) will create an app.log file in /var/log/:

```bash
bash scripts/simulate_logs.sh
```
![Image](https://github.com/user-attachments/assets/3eb50613-7015-40ea-97d1-3184e89c3c65)

### 5. Configure Log Upload
The upload script (upload_logs.sh) will compress the logs and upload them to the S3 bucket:

```bash
bash scripts/upload_logs.sh
```


### 6. Automate Log Upload with Cron
To automate the log upload every day at midnight, add the following cron job:
```bash
crontab -e
```
![Image](https://github.com/user-attachments/assets/81a0def1-738a-4689-bb67-5aaf0a5fe2f8)

Add the following line to schedule the script:
```bash
*/10 * * * * /path/to/upload_logs.sh
```

### 7. Versioning and Encryption
Ensure that your S3 bucket has versioning enabled and optionally configure server-side encryption.

![Image](https://github.com/user-attachments/assets/34870ac3-ca58-424a-8711-661fab538ba5)

![Image](https://github.com/user-attachments/assets/e5cf13ce-d879-4b87-8fe2-1820546da8f4)

### 8. Testing the Upload
Once the cron job is set, the logs will be compressed and uploaded to S3 every day. You can verify the upload and versioning in the S3 bucket using the AWS S3 console or CLI.

![Image](https://github.com/user-attachments/assets/a6b89b4a-8a2e-43e7-9bb9-cdcc5b49ad42)

File Structure
```graphql

log-archival-pipeline/
├── scripts/
│   ├── simulate_logs.sh       # Simulates application logs
│   ├── upload_logs.sh         # Compresses and uploads logs to S3
├── iam/
│   └── S3LogUploadPolicy.json # IAM policy for EC2 instance role
└── README.md                  # This file
```
Sample IAM Policy
Here is a sample IAM policy (S3LogUploadPolicy.json) that grants the EC2 instance permission to upload logs to the S3 bucket:

```json

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::bucket-name",
                "arn:aws:s3:::bucket-name/*"
            ]
        }
    ]
}
```
Where to Find the Uploaded Logs
The logs will be stored in your S3 bucket under the logs/YYYY-MM-DD/ directory, for example:

```bash

s3://your-bucket-name/logs/2025-03-30/app.log
```

You can check the S3 console for the versioned log files.
![Image](https://github.com/user-attachments/assets/a723b180-d028-4086-aa04-622a7b05a09e)

### 📝 **Explanation of Sections**:

- **Project Overview**: Brief description of the project and its purpose.
- **Prerequisites**: Details of what is needed before setting up the project.
- **Getting Started**: Step-by-step guide for setting up the log archival pipeline.
- **File Structure**: Breakdown of the directory structure and contents.
- **Sample IAM Policy**: Example IAM policy for granting the EC2 instance permission to upload logs to S3.
- **Where to Find the Uploaded Logs**: Explains where the logs will be stored in S3 and how they are organized.

This `README.md` gives someone all the information they need to understand, set up, and use the project.


