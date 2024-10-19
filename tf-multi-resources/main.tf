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

//Task 1 - We are creating 4 ec2 instance, 2 ec2 in each subnet
//Task 2 - create ec2 instance using ubuntu in one subnet , amazon linux in another subnet.

locals {
  project = "project-01"
}

resource "aws_vpc" "my-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "${local.project}-vpc"
    }
}

#Private Subnet 
resource "aws_subnet" "subnet" {
    cidr_block = "10.0.${count.index}.0/24"
    vpc_id = aws_vpc.my-vpc.id
    tags = {
        Name = "${local.project}-subnet-${count.index}"
    }
    count = 2 // It will run the block 2 times
}

#Creating 4 EC2 instance
resource "aws_instance" "name" {
    # Task 1
    # ami = "ami-0dee22c13ea7a9a67" //OS copied ubuntu ami from console
    # instance_type = "t3.micro"
    # count = 4
    # subnet_id = element(aws_subnet.subnet[*].id, count.index % length(aws_subnet.subnet))
    # #0%2 = 0
    # #1%2 = 1
    # #2%2 = 0
    # #3%2 = 1
    #tags = {
    #    Name = "${local.project}-ec2-${count.index}"
    #}

    # Task 2
    # count = length(var.ec2_config)
    # ami = var.ec2_config[count.index].ami
    # instance_type = var.ec2_config[count.index].instance_type
    # subnet_id = element(aws_subnet.subnet[*].id, count.index % length(aws_subnet.subnet))
    # # 0%2 = 0
    # # 1%2 = 1
    # tags = {
    #     Name = "${local.project}-instance-${count.index}"
    # }

    # Task 3 is same as task 2 but we are using map variable
    # We will get each.key and each.value
    for_each = var.ec2_map
    ami = each.value.ami
    instance_type = each.value.instance_type
    subnet_id = element(aws_subnet.subnet[*].id, index(keys(var.ec2_map), each.key) % length(aws_subnet.subnet))
    # 0%2 = 0
    # 1%2 = 1
    tags = {
        Name = "${local.project}-instance-${each.key}"
    }
  
}

output "aws_subnet_id" {
    value = aws_subnet.subnet[1].id  //This will will second subnet id after once we do terraform apply 
}