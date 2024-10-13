//To get the output after terraform apply
output "aws_instance_public_ip" {
    value = aws_instance.Instance-1.public_ip
}