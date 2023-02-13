variable "tags" {
  description = "Tags to apply to resources created by VPC module"
  type        = map(string)
  default = {
    name   = "katroo-project"
  }
}

# VPC variables

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "katroo-VPC"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "vpc_azs" {
  description = "Availability zones for VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_private_subnets" {
  description = "Private subnets for VPC"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.1.101.0/24", "10.1.102.0/24"]
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT gateway for VPC"
  type        = bool
  default     = true
}

# SG variables

variable "sg_name" {
  description = "Name of SG"
  type        = string
  default     = "katroo-sg"
}

# ECR variables

variable "repository_name" {
  description = "name for the ECR repository"
  type        = string
  default     = "katroo-repo"
}

variable "repository_access_arn" {
  description = "arn of user/role that have access to repository"
  type        = string
  default     = "arn:aws:iam::178851004264:user/admin"
}


# ECS variables

variable "ecs_cluster_name" {
  description = "name for the ECS cluster"
  type        = string
  default     = "katroo-cluster"
}

variable "ecs_service_name" {
  description = "name for the ECS service"
  type        = string
  default     = "katroo-service"
}

variable "ecs_td_family" {
  description = "name for the ECS task definition family"
  type        = string
  default     = "katroo-family"
}

variable "ecs_container_name" {
  description = "name for the ECS task definition family"
  type        = string
  default     = "katroo-container"
}

# LB variables

variable "lb_name" {
  description = "name for the ECS task definition family"
  type        = string
  default     = "katroo-lb"
}

variable "target_group_name" {
  description = "name for the ECS task definition family"
  type        = string
  default     = "katroo-tg"
}
