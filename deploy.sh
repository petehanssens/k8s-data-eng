#!/bin/bash

echo "Deploy EKS VPC Stack"

VPC_STACK=eks-vpc

aws cloudformation deploy \
    --stack-name ${VPC_STACK} \
    --template-file eks-vpc.yaml \
    --capabilities CAPABILITY_IAM

echo "Deploy EKS Cluster Stack"

CLUSTER_STACK=test-eks-cluster

aws cloudformation deploy \
    --stack-name ${CLUSTER_STACK} \
    --template-file eks-cluster.yaml \
    --capabilities CAPABILITY_IAM

echo "Deploy EKS Worker Nodes Stack"

WORKER_STACK=test-eks-worker-nodes

CONFIG=$(cat config/parameters.txt)
CONFIG_PARAMETERES=$(echo "${CONFIG}"|tr '\r\n' ' ')

aws cloudformation deploy \
    --stack-name ${WORKER_STACK} \
    --template-file eks-worker-nodes.yaml \
    --parameter-overrides ${CONFIG_PARAMETERES} \
    --capabilities CAPABILITY_IAM
