#Reference documentation - https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  ami = "ami-0dee22c13ea7a9a67" //OS copied ubuntu ami from console
  instance_type          = "t3.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Name   = "module-project"
    Environment = "dev"
  }
}