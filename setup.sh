#!/bin/bash
set -e

# =========================
# CONFIGURATION
# =========================
CLUSTER_NAME="demo-eks"
REGION="us-west-1"
NODEGROUP_NAME="demo-nodes"
NODE_TYPE="t3.medium"
NODE_COUNT=2
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

echo "🚀 Starting EKS setup for cluster: $CLUSTER_NAME"

# =========================
# 1. CREATE EKS CLUSTER
# =========================
echo "🔹 Creating EKS cluster..."
eksctl create cluster \
  --name $CLUSTER_NAME \
  --region $REGION \
  --nodegroup-name $NODEGROUP_NAME \
  --node-type $NODE_TYPE \
  --nodes $NODE_COUNT \
  --managed

# =========================
# 2. UPDATE KUBECONFIG
# =========================
echo "🔹 Updating kubeconfig..."
aws eks update-kubeconfig \
  --region $REGION \
  --name $CLUSTER_NAME

kubectl get nodes

# =========================
# 3. ENABLE OIDC PROVIDER
# =========================
echo "🔹 Associating IAM OIDC provider..."
eksctl utils associate-iam-oidc-provider \
  --cluster $CLUSTER_NAME \
  --region $REGION \
  --approve

# =========================
# 4. INSTALL HELM (LINUX)
# =========================
if ! command -v helm &> /dev/null
then
  echo "🔹 Installing Helm..."
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# =========================
# 5. ADD HELM REPO
# =========================
helm repo add eks https://aws.github.io/eks-charts
helm repo update

# =========================
# 6. CREATE ALB IAM POLICY
# =========================
echo "🔹 Creating ALB IAM policy (if not exists)..."
curl -s -o iam_policy.json \
  https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam_policy.json \
  2>/dev/null || echo "Policy already exists"

# =========================
# 7. CREATE IAM SERVICE ACCOUNT
# =========================
echo "🔹 Creating IAM service account for ALB controller..."
eksctl create iamserviceaccount \
  --cluster $CLUSTER_NAME \
  --region $REGION \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::$ACCOUNT_ID:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve \
  --override-existing-serviceaccounts

# =========================
# 8. INSTALL AWS LOAD BALANCER CONTROLLER
# =========================
echo "🔹 Installing AWS Load Balancer Controller..."
helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=$CLUSTER_NAME \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller

# =========================
# 9. VERIFY CONTROLLER
# =========================
echo "🔹 Verifying controller..."
kubectl get pods -n kube-system | grep aws-load-balancer-controller

echo "✅ EKS cluster setup completed successfully!"
