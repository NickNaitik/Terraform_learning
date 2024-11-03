resource "aws_efs_file_system" "name" {
  creation_token = "my-product"

  tags = {
    Name = "My-EFS"
  }
}

resource "aws_efs_mount_target" "mount-1" {
  file_system_id = aws_efs_file_system.name.id
  subnet_id      = aws_subnet.public-subnet-1.id
  security_groups = [aws_security_group.efs-sg.id]
}

# We are using multiattach ebs so we don't need to use 2

# resource "aws_efs_mount_target" "mount-2" {
#   file_system_id = aws_efs_file_system.name.id
#   subnet_id      = aws_subnet.public-subnet-2.id
# }