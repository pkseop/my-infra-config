#!/bin/bash
# Install AWS Load Balancer Controller
REGION="ap-northeast-2"
EKS_CLUSTER="{{clustername}}"
ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)

printf "Getting VPC ID: "
VPC_ID=$(aws eks describe-cluster --name $EKS_CLUSTER \
  --region $REGION \
  --query "cluster.resourcesVpcConfig.vpcId" \
  --output text)

printf "$VPC_ID\n"

printf "Associatig OIDC provider..."
eksctl utils associate-iam-oidc-provider \
  --region $REGION \
  --cluster $EKS_CLUSTER\
  --approve
printf "done\n"

printf "Downloading the IAM policy document..."
curl -Ss https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.2.0/docs/install/iam_policy.json -o iam-policy.json
printf "done\n"

printf "Creating IAM policy..."
aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam-policy.json
printf "done\n"

printf "Creating service account..."
eksctl create iamserviceaccount \
  --attach-policy-arn=arn:aws:iam::$ACCOUNT_ID:policy/AWSLoadBalancerControllerIAMPolicy \
  --cluster=$EKS_CLUSTER \
  --namespace=kube-system \
  --name=my-alb-controller \
  --override-existing-serviceaccounts \
  --region $REGION \
  --approve
printf "done\n"

printf "Installing AWS Load Balancer Controller"
helm repo add eks https://aws.github.io/eks-charts
helm repo update &>/dev/null

kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"

helm upgrade -i aws-load-balancer-controller \
  eks/aws-load-balancer-controller \
  --namespace kube-system \
  --set clusterName=$EKS_CLUSTER \
  --set serviceAccount.create=false \
  --set serviceAccount.name=my-alb-controller \
  --set vpcId=$VPC_ID \
  --set region=$REGION