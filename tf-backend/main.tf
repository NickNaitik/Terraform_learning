terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.71.0"
    }
  }
  // Remote state management
  // This will generate/update the state management file (terraform.tfstate) in s3 bucket with name backend.tfstate inside bucket - "nick-bucket-tf-c0dbb613f6b2552e"
  backend "s3" {
    bucket = "nick-bucket-tf-c0dbb613f6b2552e"
    key = "backend.tfstate"
    region = "ap-south-1" // var.region is not working here because you need to manually specify where is your state file is present.
  }
}

provider "aws" {
  # Configuration options
  region = var.region
}