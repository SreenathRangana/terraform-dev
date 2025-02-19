# Create the main VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true   # Enable DNS support
  enable_dns_hostnames = true # Enable DNS hostnames
  
  tags = {
    Name = "main-vpc"
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
    Name = "public-subnet-${count.index}"
  }
}

# Create private subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone       = element(var.azs, count.index)

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

# Create route tables for public subnets
resource "aws_route_table" "public" {
  count = length(var.public_subnet_cidrs) # Fixed variable name

  vpc_id = aws_vpc.main.id
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
}

# Create a default route for public subnets
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}



# Create ECR VPC Endpoint (Interface Type)
resource "aws_vpc_endpoint" "ecr" {
  vpc_id             = aws_vpc.main.id
  service_name       = "com.amazonaws.${var.region}.ecr.api"
 # route_table_ids         = [aws_route_table.public[0].id]
  subnet_ids         = aws_subnet.public[*].id
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]  # Specify the security group here
  private_dns_enabled = true
  vpc_endpoint_type  = "Interface"

  tags = {
    Name = "ECR VPC Endpoint"
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
    Name        = "${var.project_name}-ecs-tasks-sg"
    Environment = var.environment
  }
}
