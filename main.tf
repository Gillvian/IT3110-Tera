#provider "aws" {
#  region = "us-east-1"  # Replace with your desired AWS region
#}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.91.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Configuration options 
}


module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  public_azs = ["us-east-1a", "us-east-1b"]
  private_azs = ["us-east-1a", "us-east-1b"]
  nat_gateway_enabled = true
  tags = {
    Name = "techNova-vpc"
    Environment = "production"
  }
}

module "ec2" {
  source         = "./modules/ec2"
  ami_id         = "ami-04b4f1a9cf54c11d0"
  instance_type  = "t2.micro"
  instance_count = 2
  subnet_ids     = module.vpc.private_subnets
  vpc_id         = module.vpc.vpc_id
  target_group_arn     = module.alb.target_group_arn
  tags = {
    Name        = "techNova-ec2"
    Environment = "production"
  }
}


module "alb" {
  source            = "./modules/alb"
  subnet_ids        = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]  # Ensure different AZs
  security_group_id = module.ec2.security_group_id
  vpc_id            = module.vpc.vpc_id
  tags              = {
    Name        = "techNova-alb"
    Environment = "production"
  }
}
