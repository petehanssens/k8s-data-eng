# EKS Setup

This repo sets up a Kubernetes cluster on AWS using 3 stacks:

1. VPC stack
2. Cluster stack
3. Worker nodes stack

To reduce costs I'm using spot instances for the worker nodes.

## How to deploy

Make sure you have the aws cli installed and an aws account configured with sufficient IAM priviledges and the run:

```sh
./deploy.sh
```

## Future directions

I will be adding to this repo with further updates, including:

1. Kafka
2. Automated container deployments
3. Kafka sinks for a variety of sources
4. Automated setup of kubernetes related stuff like:
    - helm
    - prometheus