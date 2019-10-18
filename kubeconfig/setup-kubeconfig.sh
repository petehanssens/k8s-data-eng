#!/bin/bash

aws eks --region ap-southeast-2 update-kubeconfig --name test-eks-cluster

kubectl get svc

CLUSTER_INFO=$(aws eks describe-cluster --name test-eks-cluster)

CLUSTER_CERT=$(echo $CLUSTER_INFO | jq -r '.cluster.certificateAuthority.data')
CLUSTER_ENDPOINT="$(echo $CLUSTER_INFO | jq -r '.cluster.endpoint')"
CLUSTER_NAME=$(echo $CLUSTER_INFO | jq -r '.cluster.name')


ACCOUNT_ID=$(aws sts get-caller-identity --query Account)

ACCOUNT_ID=$(echo "$ACCOUNT_ID" | tr -d '"')

DEPLOYMENT_ROLE="arn:aws:iam::${ACCOUNT_ID}:role/eks-setup-admin-role"

echo $CLUSTER_ENDPOINT

cp config-devel.yaml test-config-devel.yaml

sed -i '' 's~<endpoint-url>~'${CLUSTER_ENDPOINT}'~' test-config-devel.yaml
sed -i '' 's~<base64-encoded-ca-cert>~'${CLUSTER_CERT}'~' test-config-devel.yaml
sed -i '' 's~"<cluster-name>"~'${CLUSTER_NAME}'~' test-config-devel.yaml
sed -i '' 's~"<role-arn>"~'${DEPLOYMENT_ROLE}'~' test-config-devel.yaml

cp test-config-devel.yaml ~/.kube/config-devel

export KUBECONFIG=$KUBECONFIG:~/.kube/config-devel

rm -rf test-config-devel.yaml

kubectl get svc
