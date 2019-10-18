
echo "attach worker nodes to cluster"
curl -o aws-auth-cm.yaml https://amazon-eks.s3-us-west-2.amazonaws.com/cloudformation/2019-10-08/aws-auth-cm.yaml   

INSTANCE_ROLE_ARN=$(aws cloudformation list-exports --query "Exports[?Name=='test-eks-worker-nodes-NodeInstanceRole'].Value" --output text)

sed -i '' 's~<ARN of instance role (not instance profile)>~'${INSTANCE_ROLE_ARN}'~' aws-auth-cm.yaml

kubectl apply -f aws-auth-cm.yaml

#remove aws-auth-cm.yaml
rm -rf aws-auth-cm.yaml

sleep 30

kubectl get nodes