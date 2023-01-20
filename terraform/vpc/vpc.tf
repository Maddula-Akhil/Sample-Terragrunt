# Basic VPC Configuration with 3 AZs Public and Private
# Contains the following resources:
# - Provider configuration
# - VPC
# - Internet Gateway
# - Private and Public subnets
# - Route Table
# - Route Table associations

# Setting up custom VPC for private subnets

resource "aws_vpc" "primary_vpc" {
  cidr_block           = local.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = local.app_name
  }
}

# Internet Gateway for allowing internet access in custom VPC

resource "aws_internet_gateway" "primary_igw" {
  vpc_id = aws_vpc.primary_vpc.id

  tags = {
    Name = "${local.app_name}_igw"
  }
}

# Public subnets

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = local.public_subnet_a_cidr
  availability_zone       = var.subnet_a_az
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${local.app_name}_public_subnet_a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = local.public_subnet_b_cidr
  availability_zone       = var.subnet_b_az
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${local.app_name}_public_subnet_b"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = local.public_subnet_c_cidr
  availability_zone       = var.subnet_c_az
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${local.app_name}_public_subnet_c"
  }
}

# Private subnets

resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = local.private_subnet_a_cidr
  availability_zone       = var.subnet_a_az
  map_public_ip_on_launch = "false"

  tags = {
    Name = "${local.app_name}_private_subnet_a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = local.private_subnet_b_cidr
  availability_zone       = var.subnet_b_az
  map_public_ip_on_launch = "false"

  tags = {
    Name = "${local.app_name}_private_subnet_b"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = local.private_subnet_c_cidr
  availability_zone       = var.subnet_c_az
  map_public_ip_on_launch = "false"

  tags = {
    Name = "${local.app_name}_private_subnet_c"
  }
}

# Custom route table entry for custom VPC

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.primary_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary_igw.id
  }

  tags = {
    Name = "${local.app_name}_public_route"
  }
}

# Route table associations for public subnets

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_route.id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_route.id
}
resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public_route.id
}