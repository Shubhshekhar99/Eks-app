
# -------------------------
# EKS Module
# -------------------------
module "eks" {
  source = "./modules/eks"

  cluster_name          = var.cluster_name
  subnet_ids            = [module.vpc.public1_id, module.vpc.public2_id]

  node_group_desired_size = var.node_group_desired_size
  node_group_min_size     = var.node_group_min_size
  node_group_max_size     = var.node_group_max_size
  node_instance_type      = var.node_instance_type
}
