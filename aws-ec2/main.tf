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

resource "aws_instance" "Instance-1" {

    ami = "ami-0dee22c13ea7a9a67" //OS copied ubuntu ami from console
    instance_type = "t2.micro"

    tags = {
        Name = "Web-Server-1"
    }
}