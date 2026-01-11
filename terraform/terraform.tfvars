# -------------------------
# AWS Region
# -------------------------
aws_region = "us-west-1"

# -------------------------
# Cluster Name
# -------------------------
cluster_name = "demo-eks-cluster"

# -------------------------
# VPC
# -------------------------
vpc_cidr = "10.0.0.0/16"

# -------------------------
# Public Subnets
# -------------------------
public_subnet_1_cidr = "10.0.1.0/24"
public_subnet_2_cidr = "10.0.2.0/24"

# -------------------------
# Node Group
# -------------------------
node_group_desired_size = 2
node_group_min_size     = 1
node_group_max_size     = 3
node_instance_type      = "t3.medium"
