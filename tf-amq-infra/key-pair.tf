resource "aws_key_pair" "name" {
    key_name = "tf-amq-project-key-pair"
    public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
    algorithm = "RSA"
    rsa_bits = 4096
  
}

#creating file to save private key
resource "local_file" "name" {
    content = tls_private_key.rsa.private_key_pem
    filename = "private_key"
  
}

#Connect to private IP - https://medium.com/@dianehu/how-to-ssh-to-an-private-ip-777dec23f86b

