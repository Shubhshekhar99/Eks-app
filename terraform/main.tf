module "vpc" {
  source = "./modules/vpc"

  vpc_cidr              = "10.0.0.0/16"
  private_subnet_1_cidr = "10.0.1.0/24"
  private_subnet_2_cidr = "10.0.2.0/24"
}

module "eks" {
  source       = "./modules/eks"
  cluster_name = var.cluster_name
  subnet_ids   = module.vpc.private_subnets
  vpc_id       = module.vpc.vpc_id
}
