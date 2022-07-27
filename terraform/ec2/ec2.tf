# Instance Configuration

resource "aws_instance" "ec2-instance" {
  ami           = local.ubuntu-ami-id
  instance_type = local.ec2-instance-type

  # Key pairs need to be generated separately via the console
  # The generated key_name can be used here to associate 
  key_name      = local.ec2-key-name
  associate_public_ip_address = local.ec2-public-ip-flag
  disable_api_termination = local.ec2-termination-protection
  vpc_security_group_ids = [aws_security_group.sg.id]

  credit_specification {
    cpu_credits = local.ec2-cpu-credits
  }

  root_block_device {
    delete_on_termination = local.ec2-volume-delete-on-termination
    volume_size = local.ec2-root-volume-size
  }
}

# Network Configuration

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "sg" {
  name        = local.security-group-name
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description      = "SSH Access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP Access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTPS Access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

# Elastic IP
resource "aws_eip" "eip" {
  instance = aws_instance.ec2-instance.id
  vpc      = true
}
