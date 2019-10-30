#!/bin/bash

echo "Assuming EKS deployment role"

./assume-role.sh

echo "Deploy EKS VPC Stack"

VPC_STACK=eks-vpc

aws cloudformation deploy \
    --stack-name ${VPC_STACK} \
    --template-file cloudformation/eks-vpc.yaml \
    --capabilities CAPABILITY_IAM

echo "Deploy EKS Cluster Stack"

CLUSTER_STACK=test-eks-cluster

aws cloudformation deploy \
    --stack-name ${CLUSTER_STACK} \
    --template-file cloudformation/eks-cluster.yaml \
    --capabilities CAPABILITY_IAM

echo "Deploy EKS Worker Nodes Stack"

WORKER_STACK=test-eks-worker-nodes

CONFIG=$(cat config/parameters.txt)
CONFIG_PARAMETERES=$(echo "${CONFIG}"|tr '\r\n' ' ')

aws cloudformation deploy \
    --stack-name ${WORKER_STACK} \
    --template-file cloudformation/eks-worker-nodes.yaml \
    --parameter-overrides ${CONFIG_PARAMETERES} \
    --capabilities CAPABILITY_IAM

echo "Beginning post deployment steps"

cd kubeconfig

./setup-kubeconfig.sh

cd ../join-worker-nodes

./join-worker-nodes.sh

cd ../dashboard-deploy

./dashboard-deploy.sh

cd ../helm

./deploy_helm.sh

cd ../patch-config-map

./patch-config-map.sh

cd ../alb-ingress-controller

./ingress-deploy.sh

cd ..

echo "finished deployment"