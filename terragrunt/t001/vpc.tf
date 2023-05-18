#variables

variable "region" {
  type        = string
  description = "A string representing the AWS region in which the infrastructure is being deployed. The default value is set to us-east-1"
  default     = "us-east-1"
}


variable "subnet_a_az" {
  type        = string
  description = "A string representing the availability zone for the public_a and private_a subnets. The default value is set to us-east-1a"
  default     = "us-east-1a"
}

variable "subnet_b_az" {
  type        = string
  description = "A string representing the availability zone for the public_b and private_b subnets. The default value is set to us-east-1b"
  default     = "us-east-1b"
}

variable "subnet_c_az" {
  type        = string
  description = "A string representing the availability zone for the public_c and private_c subnets. The default value is set to us-east-1c"
  default     = "us-east-1c"
}

variable "app_name" {
  type        = string
  description = "A string representing the name of the application. The default value is set to New Project"
  default     = "New Project"
}

variable "env" {
  type        = string
  description = "A string representing the environment where the application is deployed. The default value is set to dev"
  default     = "dev"
}

variable "vpc_cidr" {
  type        = string
  description = "A string representing the CIDR block for the VPC. The default value is set to 10.0.0.0/16"
  default     = "10.0.0.0/16"
}

variable "public_subnet_a_cidr" {
  type        = string
  description = "A string representing the CIDR block for the public subnet A. The default value is set to 10.0.0.0/19"
  default     = "10.0.0.0/19"
}

variable "private_subnet_a_cidr" {
  type        = string
  description = "A string representing the CIDR block for the private subnet A. The default value is set to 10.0.32.0/19"
  default     = "10.0.32.0/19"
}

variable "public_subnet_b_cidr" {
  type        = string
  description = "A string representing the CIDR block for the public subnet B. The default value is set to 10.0.64.0/19"
  default     = "10.0.64.0/19"
}

variable "private_subnet_b_cidr" {
  type        = string
  description = "A string representing the CIDR block for the private subnet B. The default value is set to 10.0.96.0/19"
  default     = "10.0.96.0/19"
}

variable "public_subnet_c_cidr" {
  type        = string
  description = "A string representing the CIDR block for the public subnet C. The default value is set to 10.0.128.0/19"
  default     = "10.0.128.0/19"
}

variable "private_subnet_c_cidr" {
  type        = string
  description = "A string representing the CIDR block for the private subnet C. The default value is set to 10.0.160.0/19"
  default     = "10.0.160.0/19"
}

#variable "terraform_version" {
#  type        = string
#  description = "A string representing the version of Terraform to use. The default value is set to v1.0.6"
#  default     = "v1.0.6"
#}

#variable "terragrunt_version" {
#  type        = string
#  description = "A string representing the version of Terragrunt to use. The default value is set to v0.34.1"
#  default     = "v0.34.1"
#}


#Resources

resource "aws_vpc" "primary_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name               = var.app_name
  }
}

# Internet_gateway

resource "aws_internet_gateway" "primary_igw" {
  vpc_id = aws_vpc.primary_vpc.id

  tags = {
    Name               = "${var.app_name}_igw"
  }
}

# Public subnets

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = var.subnet_a_az
  map_public_ip_on_launch = "true"

  tags = {
    Name               = "${var.app_name}_public_subnet_a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = var.subnet_b_az
  map_public_ip_on_launch = "true"

  tags = {
    Name               = "${var.app_name}_public_subnet_b"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = var.public_subnet_c_cidr
  availability_zone       = var.subnet_c_az
  map_public_ip_on_launch = "true"

  tags = {
    Name               = "${var.app_name}_public_subnet_c"
  }
}

# Private subnets

resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = var.private_subnet_a_cidr
  availability_zone       = var.subnet_a_az
  map_public_ip_on_launch = "false"

  tags = {
    Name               = "${var.app_name}_private_subnet_a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = var.private_subnet_b_cidr
  availability_zone       = var.subnet_b_az
  map_public_ip_on_launch = "false"

  tags = {
    Name               = "${var.app_name}_private_subnet_b"
  }
}


resource "aws_subnet" "private_c" {
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = var.private_subnet_c_cidr
  availability_zone       = var.subnet_c_az
  map_public_ip_on_launch = "false"

  tags = {
    Name               = "${var.app_name}_private_subnet_c"
  }
}

# Custom route table entry for custom VPC

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.primary_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary_igw.id
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
