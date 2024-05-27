variable "vpc_id" {
  description = "The ID of the VPC where the resources will be created"
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs where the load balancer and EC2 instance will be deployed"
}

variable "certificate_arn" { 
    description = "The ARN of the SSL certificate to be associated with the load balancer" 
}

variable "instance_id" {
  description = "The ID of the EC2 instance to be associated with the load balancer"
}
