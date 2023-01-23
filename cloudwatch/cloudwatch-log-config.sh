#!/bin/bash

# 1. namespace 생성
kubectl apply -f aws-observability-namespace.yaml

# 2. configmap 생성
kubectl apply -f aws-logging-cloudwatch-configmap.yaml

# 3. 다운로드 CloudWatch IAM policy
curl -o permissions.json https://raw.githubusercontent.com/aws-samples/amazon-eks-fluent-logging-examples/mainline/examples/fargate/cloudwatchlogs/permissions.json

# 4. IAM policy 생성
aws iam create-policy --policy-name eks-fargate-logging-policy --policy-document file://permissions.json

# 5. IAM policy를 파드에 적용
aws iam attach-role-policy \
  --policy-arn arn:aws:iam::551488187018:policy/eks-fargate-logging-policy \
  --role-name eksctl-{{cluster name}}-FargatePodExecutionRole-1X6V9FW4UCYNO
