# Variables

variable "ami" {
  type    = string
  default = "ami-06e46074ae430fba6"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = ""
}

variable "instance_name" {
  type    = string
  default = "ec2-instance"
}

variable "volume_size" {
  type    = number
  default = 8
}

variable "ingress_rules" {
  type    = list(object({
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

