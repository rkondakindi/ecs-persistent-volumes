# Below variables used for tagging
variable "owner" {
  description = "Owner of AWS resources. Eg. email/division"
  default     = "owner"
}

variable "createdby" {
  description = "AWS resourced created by. Eg. Git Repo/email"
  default     = "https://github.com/rkondakindi/ecs-persistent-volumes"
}

variable "stack_name" {
  description = "Enter stack name. All resources will be prefixed with this name"
}

variable "environment" {
  description = "Environment Name for tagging and append env name to resources"
}

# EC2
variable "aws_region" {
  description = "AWS region to deploy resources"
}

variable "key_name" {
  description = "The key name that should be used for the instance"
}

variable "sec_group" {
  description = "Security Group for EC2 instances"
}

variable "ami" {
  description = "AWS AMI ID. Use ECS optimized AMI"
  default     = "ami-09edd32d9b0990d49"
}

variable "instance_type" {
  description = "AWS EC2 Instance Type"
  default     = "t2.micro"
}

# ELB
variable "lb_name" {
  description = "LoadBalancer Name"
}

variable "alb_sg" {
  description = "Applciaton LoadBalancer Security Group ID"
}

# VPC
variable "subnets" {
  description = "Subnets will be used to create ASG. Value should be in list"
  #type        = list
}

variable "sub1" {}
variable "sub2" {}
variable "sub3" {}
variable "vpc_id" {}

# ECR
variable "cluster_name" {
  description = "ECS Cluster Name"
}

variable "ecr_repo" {
  description = "ECR Repository Name"
  default     = ""
}

variable "image_tag" {
  description = "Docker Image Tag"
}

variable "docker_image" {
  description = "The Docker image location if not using ECR"
  default     = ""
}

variable "mount_path" {
  description = "Container Path to be mounted. This is to test volume migration"
}
