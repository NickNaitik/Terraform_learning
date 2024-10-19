terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.72.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.region
}

data "aws_ami" "name" {
  most_recent = true
  owners = ["amazon"]
}

output "aws_ami" {
    value =  data.aws_ami.name.id
}


data "aws_security_group" "name" {
    tags = {
        Name = "nginx_sg" // I am fetching the sg which i created from aws-vpc-ec2-nginx project
    }
}

output "aws_security_group" {
    value =  data.aws_security_group.name.vpc_id
}

data "aws_vpc" "name" {
  tags = {
    Name = "my_tf_vpc_1" // I am fetching the vpc which i created from aws-vpc-ec2-nginx project
  }
}

output "aws_vpc" {
  value = data.aws_vpc.name.id
}

//To get the AZ in the current region
data "aws_availability_zones" "names" {
  state = "available"
}

output "aws_availability_zones" {
  value = data.aws_availability_zones.names
}

//To get the account details
data "aws_caller_identity" "name" {

}

output "caller_info" {
  value = data.aws_caller_identity.name

  # output - 
  # caller_info            = {
  #     + account_id = "476114148640"
  #     + arn        = "arn:aws:iam::476114148640:user/nick-user-1"
  #     + id         = "476114148640"
  #     + user_id    = "AIDAW5WU5LUQBNXTY7M36"
  #   }
  
}

//To get region name
data "aws_region" "name" {}

output "aws_region" {
  value = data.aws_region.name
  
}

//To get subnet_id
data "aws_subnet" "name" {
  //Filter
  filter {
    name = "vpc-id"
    values =[data.aws_vpc.name.id]
  }
  tags = {
    Name = "my_tf_private_subnet_1" //Copied private subnet from aws-vpc-ec2-nginx project VPC

  }

}

resource "aws_instance" "name" {
  ami = "ami-0dee22c13ea7a9a67" //OS copied ubuntu ami from console
  instance_type = "t3.micro"
  subnet_id = data.aws_subnet.name.id
  security_groups = [data.aws_security_group.name.id]
  tags = {
        Name = "Server_DS_1"
    }
    
}
