#!/bin/bash

ACCOUNT_ID=$(aws sts get-caller-identity --query Account)

ACCOUNT_ID=$(echo "$ACCOUNT_ID" | tr -d '"')

ASSUME_ROLE=$(aws sts assume-role --role-arn "arn:aws:iam::${ACCOUNT_ID}:role/eks-setup-admin-role" --role-session-name AWSCLI-Session)

unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN

export AWS_ACCESS_KEY_ID=$(echo $ASSUME_ROLE | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $ASSUME_ROLE | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $ASSUME_ROLE | jq -r '.Credentials.SessionToken')

aws sts get-caller-identity
