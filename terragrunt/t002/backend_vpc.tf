#variables.tf

variable "region" {
  type        = string
  description = "The region in which to create the infrastructure. The default value is us-east-1"
  default     = "us-east-1"
}

variable "backend_subnet_a_az" {
  type        = string
  description = "A string representing the availability zone for the backend_public_a and backend_private_a subnets. The default value is set to us-east-1a"
  default     = "us-east-1a"
}

variable "backend_subnet_b_az" {
  type        = string
  description = "A string representing the availability zone for the backend_public_b and backend_private_b subnets. The default value is set to us-east-1b"
  default     = "us-east-1b"
}

variable "backend_subnet_c_az" {
  type        = string
  description = "A string representing the availability zone for the backend_public_c and backend_private_c subnets. The default value is set to us-east-1c"
  default     = "us-east-1c"
}

variable "backend_app_name" {
  type        = string
  description = "The name of the backend application"
  default     = "backend"
}

variable "backend_env" {
  type        = string
  description = "A string representing the environment where the application is deployed"
  default     = ""
}

variable "backend_vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC that will contain the backend application's subnets. The default value is 10.1.0.0/16"
  default     = "10.1.0.0/16"
}

variable "backend_public_subnet_a_cidr" {
  type        = string
  description = "A string representing the CIDR block for the backend_public_a subnet. The default value is set to 10.0.0.0/19"
  default     = "10.1.0.0/19"
}

variable "backend_private_subnet_a_cidr" {
  type        = string
  description = "A string representing the CIDR block for the backend_private_a subnet. The default value is set to 10.0.32.0/19"
  default     = "10.1.32.0/19"
}

variable "backend_public_subnet_b_cidr" {
  type        = string
  description = "A string representing the CIDR block for the backend_public_b subnet. The default value is set to 10.0.64.0/19"
  default     = "10.1.64.0/19"
}

variable "backend_private_subnet_b_cidr" {
  type        = string
  description = "A string representing the CIDR block for the backend_private_b subnet. The default value is set to 10.0.96.0/19"
  default     = "10.1.96.0/19"
}

variable "backend_public_subnet_c_cidr" {
  type        = string
  description = "A string representing the CIDR block for the backend_public_c subnet. The default value is set to 10.0.128.0/19"
  default     = "10.1.128.0/19"
}

variable "backend_private_subnet_c_cidr" {
  type        = string
  description = "A string representing the CIDR block for the backend_private_c subnet. The default value is set to 10.0.160.0/19"
  default     = "10.1.160.0/19"
}

# Resources

resource "aws_vpc" "backend_vpc" {
  cidr_block           = var.backend_vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name               = "${var.backend_app_name}-${var.backend_env}-vpc"
  }
}

# Internet_gateway

resource "aws_internet_gateway" "backend_igw" {
  vpc_id = aws_vpc.backend_vpc.id

  tags = {
    Name               = "${var.backend_app_name}-igw"
  }
}

# Public subnets

resource "aws_subnet" "backend_public_a" {
  vpc_id                  = aws_vpc.backend_vpc.id
  cidr_block              = var.backend_public_subnet_a_cidr
  availability_zone       = var.backend_subnet_a_az
  map_public_ip_on_launch = "true"

  tags = {
    Name               = "${var.backend_app_name}-${var.backend_env}-public-subnet-a"
  }
}

resource "aws_subnet" "backend_public_b" {
  vpc_id                  = aws_vpc.backend_vpc.id
  cidr_block              = var.backend_public_subnet_b_cidr
  availability_zone       = var.backend_subnet_b_az
  map_public_ip_on_launch = "true"

  tags = {
    Name               = "${var.backend_app_name}-${var.backend_env}-public-subnet-b"
  }
}

resource "aws_subnet" "backend_public_c" {
  vpc_id                  = aws_vpc.backend_vpc.id
  cidr_block              = var.backend_public_subnet_c_cidr
  availability_zone       = var.backend_subnet_c_az
  map_public_ip_on_launch = "true"

  tags = {
    Name               = "${var.backend_app_name}-${var.backend_env}-public-subnet-c"
  }
}

# Private subnets

resource "aws_subnet" "backend_private_a" {
  vpc_id                  = aws_vpc.backend_vpc.id
  cidr_block              = var.backend_private_subnet_a_cidr
  availability_zone       = var.backend_subnet_a_az
  map_public_ip_on_launch = "false"

  tags = {
    Name               = "${var.backend_app_name}-${var.backend_env}-private-subnet-a"
  }
}

resource "aws_subnet" "backend_private_b" {
  vpc_id                  = aws_vpc.backend_vpc.id
  cidr_block              = var.backend_private_subnet_b_cidr
  availability_zone       = var.backend_subnet_b_az
  map_public_ip_on_launch = "false"

  tags = {
    Name               = "${var.backend_app_name}-${var.backend_env}-private-subnet-b"
  }
}


resource "aws_subnet" "backend_private_c" {
  vpc_id                  = aws_vpc.backend_vpc.id
  cidr_block              = var.backend_private_subnet_c_cidr
  availability_zone       = var.backend_subnet_c_az
  map_public_ip_on_launch = "false"

  tags = {
    Name               = "${var.backend_app_name}-${var.backend_env}-private-subnet-c"
  }
}



resource "aws_route_table" "backend_public_route" {
  vpc_id = aws_vpc.backend_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.backend_igw.id
  }

  tags = {
    Name               = "${var.backend_app_name}-public-route"
  }
}

# Route table associations for public subnets

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.backend_public_a.id
  route_table_id = aws_route_table.backend_public_route.id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.backend_public_b.id
  route_table_id = aws_route_table.backend_public_route.id
}
resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.backend_public_c.id
  route_table_id = aws_route_table.backend_public_route.id
}

