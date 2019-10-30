#!/usr/bin/env bash

echo "Deploying Helm"

./install_helm.sh

kubectl apply -f tiller_user.yaml

helm init --service-account tiller
