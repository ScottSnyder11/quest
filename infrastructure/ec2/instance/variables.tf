variable "ami_id" {
  description = "The ID of the AMI to use for the EC2 instance"
}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  default     = "t2.micro"
}

variable "docker_image_name" {
  description = "The name of the docker image hosted on Docker Hub"
}

variable "vpc_id" {
  description = "The ID of the VPC where the resources will be created"
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs where the load balancer and EC2 instance will be deployed"
}

variable "alb_sg_id" {
  description = "The security group ID of the ALB"
  type        = string
}

variable "iam_instance_profile" {
  description = "The IAM instance profile ID"
  type        = string
}