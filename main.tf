terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
region = "us-east-1"
#access_key = 
#secret_key = 
}

# 1. Create VPC

resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production"
  }
}

# 2. Create Internet Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id #associate internet gateway to VPC 

  tags = {
    Name = "prod-InternetGateway"
  }
}

# 3. Create Custom Route Table 

resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id #associate route table to VPC

  route {
    cidr_block = "0.0.0.0/0" # default route, all traffic gets routed to this Internet Gateway.
    gateway_id = aws_internet_gateway.gw.id #associate Internet Gateway to Route table. 
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Prod"
  }
}

# 4. Create a Subnet 

resource "aws_subnet" "subnet-1" {
    vpc_id = aws_vpc.prod-vpc.id # Associate Subnet with VPC
    cidr_block = "10.0.1.0/24"   # Subnet address/route
    availability_zone = "us-east-1a"

    tags = {
        Name = "prod-subnet"
    }
  }

# 5. Associate Subnet with Route Table

resource "aws_route_table_association" "a" {
  subnet_id = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id
}

# 6. Create Security Group to allow port 22,80,443
# 7. Create a network interface with an IP in the Subnet that was created in Step 4
# 8. Assign an elastic IP to the network interface creater in Step 7. 
# 9. Create Ubuntu server and install/enable Apache2