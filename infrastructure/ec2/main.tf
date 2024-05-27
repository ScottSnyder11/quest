# Import the AMI and EC2 instance resources from their respective files
module "ec2_ami" {
  source = "./ami"
}

# Build an application load balancer with the specific ACM certificate and apply it to https traffic.
module "load_balancer" {
  source = "./load_balancer"
  instance_id = [module.ec2_instance.instance_id]
  subnet_ids = var.subnet_ids
  vpc_id = var.vpc_id
  certificate_arn = var.certificate_arn
}

# Create IAM Role for EC2 Instance
module "iam_role" {
  source      = "./iam_role"
  role_name   = "ec2_secrets_manager_role"
  policy_name = "ec2_secrets_manager_policy"
}


# Build an EC2 instance with the specified Docker image and within the subnet list that was applied to the ALB.
module "ec2_instance" {
  source            = "./instance"
  ami_id            = module.ec2_ami.ami_id
  docker_image_name = var.docker_image_name
  subnet_ids        = var.subnet_ids
  alb_sg_id         = module.load_balancer.alb_sg_id
  vpc_id = var.vpc_id
  iam_instance_profile = module.iam_role.instance_profile_id
}
