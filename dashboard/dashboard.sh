#!/bin/bash

# 1. metric server 설치
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
# metric server가 정상적으로 올라오는지 확인
kubectl get deployment metrics-server -n kube-system

# 2. 대시보드를 fargate에서 실행하기 위해 farget profile 설치
eksctl create fargateprofile --cluster {{clustername}} --region ap-northeast-2 --name k8s-dashboard --namespace kubernetes-dashboard

# 3. 대시보드 설치
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.5/aio/deploy/recommended.yaml

# 4. 서비스 계정 및 클러스터 역할 바인딩을 클러스터에 적용
kubectl apply -f eks-admin-service-account.yaml

# 5. 대시보드 연결
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')
# kubectl proxy 시작
kubectl proxy
# 다음 url로 접속
# http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#!/login