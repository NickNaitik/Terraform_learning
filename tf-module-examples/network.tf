#Documentation link - https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
#Reference official github repo - https://github.com/terraform-aws-modules/terraform-aws-vpc

provider "aws" {
    region = "ap-south-1"
}

data "aws_availability_zones" "name" {
    state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.14.0"

  name = "my-module-vpc"
  
  azs = data.aws_availability_zones.name.names
  public_subnets = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnets = ["10.0.2.0/24", "10.0.3.0/24"]

  tags = {
    Name ="test-vpc-module"
  }
}