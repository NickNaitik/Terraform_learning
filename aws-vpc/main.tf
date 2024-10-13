terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.71.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.region
}

resource "aws_vpc" "my-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my_tf_vpc"
    }
}

#Private Subnet 
resource "aws_subnet" "private-subnet" {
    cidr_block = "10.0.1.0/28"
    vpc_id = aws_vpc.my-vpc.id
    tags = {
        Name = "my_tf_private_subnet"
    }
}

#Public Subnet 
resource "aws_subnet" "public-subnet" {
    cidr_block = "10.0.2.0/24"
    vpc_id = aws_vpc.my-vpc.id
    tags = {
        Name = "my_tf_public_subnet"
    }
}

// Internet Gateway
resource "aws_internet_gateway" "my-igw" {
    vpc_id = aws_vpc.my-vpc.id
    tags = {
      Name = "my_tf_igw"
    }
}

#Routing table
resource "aws_route_table" "my-rt" {
    vpc_id = aws_vpc.my-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-igw.id
    }
    tags = {
      Name = "my_tf_rt"
    }
}

// Associating subnet and route table
resource "aws_route_table_association" "public-sub-rt-ass" {
  route_table_id = aws_route_table.my-rt.id
  subnet_id = aws_subnet.public-subnet.id
}

// creating instance in VPC 
resource "aws_instance" "vpc-instance-1" {

    ami = "ami-0dee22c13ea7a9a67" //OS copied ubuntu ami from console
    instance_type = "t3.micro"
    subnet_id = aws_subnet.public-subnet.id
    associate_public_ip_address = true // This will give public IP
    tags = {
        Name = "Sample-Server-1"
    }
}