#variable

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
  default = "my-ec2-instance"
}

variable "volume_size" {
  type    = number
  default = 8
}

#resource

resource "aws_instance" "my_ec2_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  #key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.my_sg.id]
  subnet_id              = aws_subnet.public_a.id

  root_block_device {
    volume_size = var.volume_size
  }

  tags = {
    Name = var.instance_name
  }
}

resource "aws_security_group" "my_sg" {
  name        = "my-ec2-instance-Sg"
  description = "Security Group for my_ec2_instance"
  vpc_id      = aws_vpc.primary_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

