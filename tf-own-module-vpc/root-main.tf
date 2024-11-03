provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "./module/vpc" //given path of module

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name = "my-own-root-vpc"
  }

  subnet_config = {
    public_subnet = {
        cidr_block = "10.0.1.0/24"
        az = "ap-south-1a"
        public = true
    }
    public_subnet-2 = {
        cidr_block = "10.0.3.0/24"
        az = "ap-south-1a"
        public = true
    }

    private_subnet = {
        cidr_block = "10.0.2.0/24"
        az = "ap-south-1b"
    }
  }
}