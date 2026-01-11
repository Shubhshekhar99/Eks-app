variable "cluster_name" {}
variable "subnet_ids" {
  type = list(string)
}

variable "node_group_desired_size" {}
variable "node_group_min_size" {}
variable "node_group_max_size" {}
variable "node_instance_type" {}
