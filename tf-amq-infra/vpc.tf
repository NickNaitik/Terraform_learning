resource "aws_vpc" "my-vpc-1" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
        Name = "tf-amq-project-vpc"
    }
}

#Private Subnet 
resource "aws_subnet" "private-subnet-1" {
    cidr_block = "10.0.105.0/24"
    vpc_id = aws_vpc.my-vpc-1.id
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true //This will help to map public ip by default it will false
    tags = {
        Name = "tf-amq-project-private-subnet"
    }
}

#Private Subnet 
resource "aws_subnet" "private-subnet-2" {
    cidr_block = "10.0.106.0/24"
    vpc_id = aws_vpc.my-vpc-1.id
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true //This will help to map public ip by default it will false
    tags = {
        Name = "tf-amq-project-private-subnet"
    }
}

#Public Subnet 
resource "aws_subnet" "public-subnet" {
    cidr_block = "10.0.107.0/24"
    vpc_id = aws_vpc.my-vpc-1.id
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true //This will help to map public ip by default it will false
    tags = {
        Name = "tf-amq-project-public-subnet"
    }
}

#Public Subnet 
resource "aws_subnet" "public-subnet-1" {
    cidr_block = "10.0.108.0/24"
    vpc_id = aws_vpc.my-vpc-1.id
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true //This will help to map public ip by default it will false
    tags = {
        Name = "tf-amq-project-public-subnet"
    }
}

#Public Subnet 
resource "aws_subnet" "public-subnet-2" {
    cidr_block = "10.0.109.0/24"
    vpc_id = aws_vpc.my-vpc-1.id
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true //This will help to map public ip by default it will false
    tags = {
        Name = "tf-amq-project-public-subnet"
    }
}

// Internet Gateway
resource "aws_internet_gateway" "my-igw-1" {
    vpc_id = aws_vpc.my-vpc-1.id
    tags = {
      Name = "tf-amq-project-igw"
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
      Name = "tf-amq-project-rt-1"
    }
}

// Associating subnet and route table
resource "aws_route_table_association" "public-sub-rt-ass" {
  route_table_id = aws_route_table.my-rt-1.id
  subnet_id = aws_subnet.public-subnet.id
}

resource "aws_route_table_association" "public-sub-rt-ass-1" {
  route_table_id = aws_route_table.my-rt-1.id
  subnet_id = aws_subnet.public-subnet-1.id
}

resource "aws_route_table_association" "public-sub-rt-ass-2" {
  route_table_id = aws_route_table.my-rt-1.id
  subnet_id = aws_subnet.public-subnet-2.id
}
