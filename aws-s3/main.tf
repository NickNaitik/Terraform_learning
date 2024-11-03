terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.71.0"
    }
    //To generate random unique bucket name or string
    random = {
      source = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.region
}

resource "aws_s3_bucket" "demo-bucket" {
    bucket = "nick-bucket-tf-${random_id.rand_id.hex}" // this should be globally unique
}

//This will upload the data to bucket
resource "aws_s3_object" "bucket-txt-data" {
    bucket = aws_s3_bucket.demo-bucket.bucket
    source = "./file1.txt" //local path
    key = "tf_file1.txt" // File name in aws s3 bucket
}

provider "random" {
  # Configuration options
}

resource "random_id" "rand_id" {
    byte_length = 8
}