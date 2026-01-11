variable "aws_region" {
  type    = string
  
}

variable "cluster_name" {
  type    = string
  
}

variable "vpc_cidr" {
  type    = string

}

variable "public_subnet_1_cidr" {
  type    = string
}

variable "public_subnet_2_cidr" {
  type    = string

}

variable "node_group_desired_size" {
  type    = number
}

variable "node_group_min_size" {
  type    = number
  
}

variable "node_group_max_size" {
  type    = number
  
}

variable "node_instance_type" {
  type    = string
  
}
