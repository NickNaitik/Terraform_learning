resource "aws_security_group" "amq-sg" {
  vpc_id = aws_vpc.my-vpc-1.id

  #Inbound rule for HTTP
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8161
    to_port = 8161
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 61616
    to_port = 61616
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 61617
    to_port = 61617
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outbout rule
  egress {
    from_port = 0
    to_port = 0 
    protocol = -1 // This will allow all protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-amq-project-sg"
  }
}

resource "aws_security_group" "efs-sg" {
  vpc_id = aws_vpc.my-vpc-1.id

  #Inbound rule for HTTP
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 2049
    to_port = 2049
    protocol = "tcp"
    cidr_blocks = ["10.0.108.0/24","10.0.109.0/24"]
  }

  ingress {
    from_port = 2049
    to_port = 2049
    protocol = "tcp"
    cidr_blocks = ["10.0.109.0/24"]
  }

  #Outbout rule
  egress {
    from_port = 0
    to_port = 0 
    protocol = -1 // This will allow all protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-efs-sg"
  }
}


#Jumphost - https://medium.com/@happynehra/simple-guide-to-bastion-hosts-jump-box-cc72261b736c