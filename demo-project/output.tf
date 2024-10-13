//Step 7
//To get the output after terraform apply
output "Website_URL" {
    value = aws_s3_bucket_website_configuration.my-web-app-bucket-configuration.website_endpoint
}