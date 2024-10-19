ec2_config = [ {
    ami = "ami-0dee22c13ea7a9a67" #ubuntu
    instance_type ="t3.micro"
}, {
    ami = "ami-04a37924ffe27da53" #amazon linux
    instance_type ="t3.micro"
} ]

ec2_map = {
  "ubuntu_ec2" = {
    ami = "ami-0dee22c13ea7a9a67" #ubuntu
    instance_type ="t3.micro"
  },
  "amazon_linux" = {
    ami = "ami-04a37924ffe27da53" #amazon linux
    instance_type ="t3.micro"
  }
}