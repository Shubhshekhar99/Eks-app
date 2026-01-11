output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = [module.vpc.public1_id, module.vpc.public2_id]
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
