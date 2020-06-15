#!/bin/bash
AWS_ACCOUNT_ID=$1
AWS_REGION=$2
ECR_REPO=$3
TAG=$4

if [ ! "$#" -eq 4 ]; then
  echo "Provide required arguments in the order"
  echo "Usage: $0 <aws_account_id> <aws_region> <ecr_repo> <image_tag>"
  exit 1
fi

command -v aws >/dev/null
if [ $? -eq 0 ]; then
  DOCKER_LOGIN=$(aws ecr get-login --region $AWS_REGION --no-include-email --profile my-profile)
  eval ${DOCKER_LOGIN}
  docker build -t myrepo .
  docker tag myrepo:latest ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${ECR_REPO}:${TAG}
  docker push ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${ECR_REPO}:${TAG}
else
  echo "AWS CLI is not installed in your system. Please install and run the script again"
fi