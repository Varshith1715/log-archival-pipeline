#!/bin/bash
# Variables
LOG_FILE="/var/log/app.log"
BUCKET_NAME="my-bucket-var"
DATE=$(date +'%Y-%m-%d')
S3_PATH="logs/$DATE/app.log.gz"

# Compress the log file
gzip -c $LOG_FILE > /tmp/app.log.gz

# Upload to S3
aws s3 cp /tmp/app.log.gz s3://$BUCKET_NAME/$S3_PATH

# Check if the upload was successful
if [ $? -eq 0 ]; then
  echo "$(date) - SUCCESS: Log file uploaded to S3 at $S3_PATH" >> /var/log/upload.log
  # Clear the log after upload
  : > $LOG_FILE
else
  echo "$(date) - ERROR: Failed to upload log file" >> /var/log/upload.log
fi

