resource "aws_s3_bucket" "demo-bucket" {
    bucket = "tf-amq-project-${random_id.rand_id.hex}" // this should be globally unique
}

//This will upload the data to bucket
resource "aws_s3_object" "bucket-txt-data" {
    bucket = aws_s3_bucket.demo-bucket.bucket
    source = "./amq/apache-artemis-2.38.0-bin.zip" //local path
    key = "/amq/apache-artemis-2.38.0-bin.zip" // File name in aws s3 bucket
}

provider "random" {
  # Configuration options
}

resource "random_id" "rand_id" {
    byte_length = 8
}