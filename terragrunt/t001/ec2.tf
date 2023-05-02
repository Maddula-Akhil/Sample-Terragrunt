# Variables

variable "ami" {
  type        = string
  description = "The ID of the AMI to use for the instance."
  default     = "ami-06e46074ae430fba6"
}

variable "instance_type" {
  type        = string
  description = "The instance type to launch."
  default     = "t2.micro"
}

variable "key_name" {
  type        = string
  description = "The name of the EC2 key pair to associate with the instance."
  default     = ""
}

variable "instance_name" {
  type        = string
  description = "The name of the EC2 instance"
  default     = "ec2-instance"
}

variable "volume_size" {
  type        = number
  description = "The size of the root volume in GB."
  default     = 8
}

variable "terraform_version" {
  type        = string
  description = "The version of Terraform to use."
  default     = "v1.0.6"
}

variable "terragrunt_version" {
  type        = string
  description = "The version of Terragrunt to use."
  default     = "v0.34.1"
}


variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  description = "A list of ingress rules to apply to the EC2 instance's security group."
}


# Resources

# ec2 instances

resource "aws_instance" "ec2_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  #key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id              = aws_subnet.public_a.id

  root_block_device {
    volume_size = var.volume_size
  }

  tags = {
    Name = var.instance_name
    terraform_version  = var.terraform_version
    terragrunt_version = var.terragrunt_version
  }
}

# ec2 security group

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-instance-Sg"
  description = "Security Group for ec2_instance"
  vpc_id      = aws_vpc.primary_vpc.id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
