Copy
##!/bin/bash
CLUSTER_NAME={{cludstername}}
REGION=ap-northeast-2
SERVICE_ACCOUNT_NAMESPACE=fargate-container-insights
SERVICE_ACCOUNT_NAME=adot-collector
SERVICE_ACCOUNT_IAM_ROLE=My-EKS-Fargate-ADOT-ServiceAccount-Role
SERVICE_ACCOUNT_IAM_POLICY=arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy
SERVICE_ACCOUNT_IAM_POLICY2=arn:aws:iam::aws:policy/AWSXrayFullAccess

eksctl utils associate-iam-oidc-provider \
--cluster=$CLUSTER_NAME \
--approve

eksctl create iamserviceaccount \
--cluster=$CLUSTER_NAME \
--region=$REGION \
--name=$SERVICE_ACCOUNT_NAME \
--namespace=$SERVICE_ACCOUNT_NAMESPACE \
--role-name=$SERVICE_ACCOUNT_IAM_ROLE \
--attach-policy-arn=$SERVICE_ACCOUNT_IAM_POLICY \
--attach-policy-arn=$SERVICE_ACCOUNT_IAM_POLICY2 \
--approve \
--override-existing-serviceaccounts