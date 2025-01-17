#!/bin/bash
# Requires AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html

set -euo pipefail

# Variables:

##### NOTE: THE BELOW VARIABLES MUST BE SET! ######
# Name of an S3 bucket to be created -- MUST BE GLOBALLY UNIQUE!
S3_BUCKET=MY-UNIQUE-BUCKETNAME
# AWS Account IDs
DEV_ACCOUNT_ID=123456789123
PROD_ACCOUNT_ID=123456789123

###### THESE VARIABLES CAN BE OPTIONALLY ADJUSTED ######
# Prefix for files in S3 bucket. Default is fine for most scenarios.
S3_PREFIX=AWS-CICD-Quickstart
# A name for your CloudFormation stack 
STACK_NAME=cicd-serverless

# Create S3 bucket for CloudFormation sub-templates
echo "Creating S3 bucket and uploading sub-templates"
aws s3 mb s3://${S3_BUCKET}

# Upload templates to S3
aws s3 cp ./ s3://${S3_BUCKET}/${S3_PREFIX} --recursive

# Deploy Quick Start CloudFormation stack
echo "Deploying CloudFormation stack"
aws cloudformation deploy \
    --template-file ./templates/full-stack.template.yaml \
    --stack-name ${STACK_NAME} \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides DevAwsAccountId=${DEV_ACCOUNT_ID} ProdAwsAccountId=${PROD_ACCOUNT_ID} QSS3BucketName=${S3_BUCKET} QSS3KeyPrefix="${S3_PREFIX}/"
echo "Deploy successful"
