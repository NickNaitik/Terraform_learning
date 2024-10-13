resource "aws_vpc" "my-vpc-1" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my_tf_vpc_1"
    }
}

#Private Subnet 
resource "aws_subnet" "private-subnet-1" {
    cidr_block = "10.0.1.0/28"
    vpc_id = aws_vpc.my-vpc-1.id
    tags = {
        Name = "my_tf_private_subnet_1"
    }
}

#Public Subnet 
resource "aws_subnet" "public-subnet-1" {
    cidr_block = "10.0.2.0/24"
    vpc_id = aws_vpc.my-vpc-1.id
    map_public_ip_on_launch = true //This will help to map public ip by default it will false
    tags = {
        Name = "my_tf_public_subnet_1"
    }
}

// Internet Gateway
resource "aws_internet_gateway" "my-igw-1" {
    vpc_id = aws_vpc.my-vpc-1.id
    tags = {
      Name = "my_tf_igw_1"
    }
}

#Routing table
resource "aws_route_table" "my-rt-1" {
    vpc_id = aws_vpc.my-vpc-1.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-igw-1.id
    }
    tags = {
      Name = "my_tf_rt_1"
    }
}

// Associating subnet and route table
resource "aws_route_table_association" "public-sub-rt-ass-1" {
  route_table_id = aws_route_table.my-rt-1.id
  subnet_id = aws_subnet.public-subnet-1.id
}