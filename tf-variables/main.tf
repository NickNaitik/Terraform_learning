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

locals {
  instance_name="tf-var-server"
}

resource "aws_instance" "my-tf-variable-server" {
  ami = "ami-0dee22c13ea7a9a67" //OS copied ubuntu ami from console
  instance_type = var.instance_type
  root_block_device {
    delete_on_termination = true
    # volume_size = var.root_volume_size
    # volume_type = var.root_vol_type
    volume_size = var.ec2_config.v_size
    volume_type = var.ec2_config.v_type
  }
//It will merge tags
  tags = merge(var.additional_tags, {
    Name = local.instance_name
  })
  
}