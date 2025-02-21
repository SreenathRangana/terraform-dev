# Create the main VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true # Enable DNS support
  enable_dns_hostnames = true # Enable DNS hostnames

  tags = {
      Name = "${var.env_name}-${var.project_name}-vpc"
    }
}


# Create public subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_name}-${var.project_name}-public-subnet-${count.index}"
  }
}

# Create private subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.env_name}-${var.project_name}-private-subnet-${count.index}"
  }
}

# Create route tables for public subnets
resource "aws_route_table" "public" {
  count  = length(var.public_subnet_cidrs) # Fixed variable name
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env_name}-${var.project_name}-rt"
  }
}

# Associate route tables with public subnets
resource "aws_route_table_association" "public_association" {
  count          = length(var.public_subnet_cidrs) # Fixed variable name
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

# Create an internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env_name}-${var.project_name}-igw"
  }
}

# Create a default route for public subnets
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Allocate Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.env_name}-${var.project_name}-nat-eip"
  }
}

# Create a NAT Gateway in Public Subnet
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id # NAT must be in a public subnet

  tags = {
    Name = "${var.env_name}-${var.project_name}-nat"
  }
}


# Create a route table for private subnets
resource "aws_route_table" "pvt_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env_name}-${var.project_name}-pvt-rt"
  }
}

# Add NAT Gateway Route to Private Route Table
resource "aws_route" "pvt_nat_route" {
  route_table_id         = aws_route_table.pvt_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
  lifecycle {
    ignore_changes = [destination_cidr_block]
  }
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "pvt_rt_assoc" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.pvt_rt.id
}

# Create ECR VPC Endpoint (Interface Type)
resource "aws_vpc_endpoint" "ecr" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.ecr.api"
  subnet_ids          = aws_subnet.public[*].id
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id] # Specify the security group here
  private_dns_enabled = true
  vpc_endpoint_type   = "Interface"

  tags = {
    Name = "${var.env_name}-${var.project_name}-ecr-endpoint"
  }

}

# Create a security group for the VPC Endpoint
resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "vpc-endpoint-sg"
  description = "Security group for VPC endpoint"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_name}-${var.project_name}-vpc-endpoint-sg"
  }
}