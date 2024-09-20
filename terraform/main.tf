provider "aws" {
  region = "ap-south-1"  # Update to your desired region
}

module "vpc" {
  source              = "./modules/vpc"
  cidr_block          = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  availability_zone   = "ap-south-1a"
  name                = "circleci-vpc"
}

module "ecr" {
  source = "./modules/ecr"
  name   = "circleci-app"
}

module "ec2" {
  source         = "./modules/ec2"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_id
  ami           = "ami-0522ab6e1ddcc7055"  # Update to your desired AMI
  instance_type = "t3.micro"
  name          = "circleci-ec2-instance"
}
