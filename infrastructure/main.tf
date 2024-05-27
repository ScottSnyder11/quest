terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#Load EC2 module and create ec2 resource.

module "ec2" {
  source = "./ec2"
  vpc_id = var.vpc_id
  subnet_ids = var.subnet_ids
  certificate_arn = var.certificate_arn
  docker_image_name = var.docker_image_name
  
}


#required for Terraform HCP
terraform {
  cloud {
    organization = "snyclone"

    workspaces {
      name = "rearc-quest"
    }
  }
}