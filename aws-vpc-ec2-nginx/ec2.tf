// creating instance in VPC 
resource "aws_instance" "nginx-server" {

    ami = "ami-0dee22c13ea7a9a67" //OS copied ubuntu ami from console
    instance_type = "t3.micro"
    subnet_id = aws_subnet.public-subnet-1.id
    vpc_security_group_ids = [aws_security_group.nginx-sg.id]
    associate_public_ip_address = true // This will give public IP
    
    // This will install nginx server
    user_data = <<-EOF
              #!/bin/bash
              sudo yum install nginx -y
              sudo systemctl start nginx
              EOF
    tags = {
        Name = "Nginx_Server_1"
    }
}