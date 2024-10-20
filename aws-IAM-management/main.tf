terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.72.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.region
}

locals {
  // it will fetch only user data
  user_data = yamldecode(file("./users.yaml")).users

  //It will create a list for each with different Roles - imag1
  // it is like nested 
  user_role_pair = flatten([for user in local.user_data:  [for role in user.roles : {
    username = user.username
    role = role
  }]])

  # The flatten function in Terraform is used to transform a list of lists into a single, flat list - (same as flatmap of java i guess)


}

output "output" {
  #value = local.user_data[*].username
  value = local.user_role_pair
}

# Creating Users
resource "aws_iam_user" "users" {
  
  for_each = toset(local.user_data[*].username)
  name = each.value
  
}

#Password Creation
resource "aws_iam_user_login_profile" "profile" {
  for_each = aws_iam_user.users
  user = each.value.name
  password_length = 20
  password_reset_required = true

  lifecycle {
    ignore_changes = [ 
      password_length,
      password_reset_required,
      password,
      pgp_key
     ]
  }
}

#Attaching Policies
resource "aws_iam_user_policy_attachment" "name" {
  for_each = {
    for pair in local.user_role_pair :
    "${pair.username}-${pair.role}" => pair
  }

  #baburao-Ec2Access = {username = baburao, role = Ec2Access}
  #baburao-S3Access = {username = baburao, role = S3Access}

  user = aws_iam_user.users[each.value.username].name
  policy_arn = "arn:aws:iam::aws:policy/${each.value.role}"
}

# Additionally what i need to do - 
# MFA Enabled for the user who have FullEc2 & FullS3 access
# SSO Enabled for other user with readOnlyAccess