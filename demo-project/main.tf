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

// Step 1-  Created Bucket
resource "aws_s3_bucket" "my-web-app-bucket" {
    bucket = "my-webapp-bucket-tf-${random_id.rand_id.hex}" // this should be globally unique
}

// Step 2 - Setting for allow public access
// Reference here - https://registry.terraform.io/providers/tfproviders/aws/latest/docs/resources/s3_bucket_public_access_block
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.my-web-app-bucket.id
  block_public_acls   = false
  block_public_policy = false
}

//Step 3 - Applying policy in bucket
//Applying policy in bucket so that it can be accessible over internet for all public ips
resource "aws_s3_bucket_policy" "my-web-app-bucket_policy" {
  bucket = aws_s3_bucket.my-web-app-bucket.id
  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Sid = "PublicReadGetObject",
          Effect = "Allow",
          Principal = "*",
          Action = "s3:GetObject",
          Resource = "arn:aws:s3:::${aws_s3_bucket.my-web-app-bucket.id}/*"
        }
      ]
    }
  )
}

//Step 4 - Static URL
//It will give the static website link here - https://ap-south-1.console.aws.amazon.com/s3/buckets/my-webapp-bucket-tf-16ef8914d5a4b65c?region=ap-south-1&bucketType=general&tab=properties
resource "aws_s3_bucket_website_configuration" "my-web-app-bucket-configuration" {
  bucket = aws_s3_bucket.my-web-app-bucket.id

  index_document {
    suffix = "index.html"
  }
  
}

//Step 5
//This will upload the data to bucket
resource "aws_s3_object" "index_html" {
    bucket = aws_s3_bucket.my-web-app-bucket.bucket
    source = "./index.html" //local path 
    key = "index.html" // File name in aws s3 bucket
    content_type = "text/html" // if we don't give then from hosting url it will just owwnload index.html file.
}

//Step 6
//This will upload the data to bucket
resource "aws_s3_object" "style_css" {
    bucket = aws_s3_bucket.my-web-app-bucket.bucket
    source = "./style.css" //local path
    key = "style.css" // File name in aws s3 bucket
    content_type = "text/css"
}

provider "random" {
  # Configuration options
}

resource "random_id" "rand_id" {
    byte_length = 8
}
