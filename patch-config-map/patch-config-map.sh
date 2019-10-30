#!/usr/bin/env bash

echo "Patching config map"

ACCOUNT_ID=$(aws sts get-caller-identity --query Account)

ACCOUNT_ID=$(echo "$ACCOUNT_ID" | tr -d '"')

ROLE="    - rolearn: arn:aws:iam::${ACCOUNT_ID}:role/eks-setup-admin-role\n      username: build\n      groups:\n        - system:masters"

kubectl get -n kube-system configmap/aws-auth -o yaml | awk "/mapRoles: \|/{print;print \"$ROLE\";next}1" > /tmp/aws-auth-patch.yml

kubectl patch configmap/aws-auth -n kube-system --patch "$(cat /tmp/aws-auth-patch.yml)"
