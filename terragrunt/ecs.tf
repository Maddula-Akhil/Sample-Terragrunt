# Variables

variable "aws_region" {
  description = "AWS region to create resources in"
  default     = "us-east-1"
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  default     = "backend-cluster"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  default     = "ami-02396cdd13e9a1257"
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  default     = "t2.micro"
}

variable "backend_ecr_repository_url" {
  type        = string
  description = "URL of the ECR repository where the Docker image for the ECS tasks is stored"
  default     = "006498139126.dkr.ecr.us-east-1.amazonaws.com/node:latest"
}


variable "container_port" {
  description = "The port number on the container that the task should listen to"
  type        = number
  default     = 80
}

variable "host_port" {
  description = "The port number on the container instance to reserve for the task"
  type        = number
  default     = 80
}

variable "sg_name_prefix" {
  type        = string
  default     = "backend"
  description = "Prefix for the name of the security group"
}

variable "ingress_port_range" {
  type        = map(number)
  default     = { from = 0, to = 65535 }
  description = "The range of ports to allow ingress traffic for"
}

variable "ingress_protocol" {
  type        = string
  default     = "tcp"
  description = "The protocol to allow ingress traffic for"
}

variable "ingress_cidr_blocks" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "The list of CIDR blocks to allow ingress traffic from"
}

variable "egress_port_range" {
  type        = map(number)
  default     = { from = 0, to = 0 }
  description = "The range of ports to allow egress traffic for"
}

variable "egress_protocol" {
  type        = string
  default     = "-1"
  description = "The protocol to allow egress traffic for"
}

variable "egress_cidr_blocks" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "The list of CIDR blocks to allow egress traffic to"
}

variable "sg_tags" {
  type        = map(string)
  default     = { Name = "ecs-sg" }
  description = "A map of tags to add to the security group"
}


# Resources

resource "aws_ecs_cluster" "backend_ecs_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_service" "backend_service" {
  name                               = "backend-service"
  cluster                            = aws_ecs_cluster.backend_ecs_cluster.id
  desired_count                      = 1
  task_definition                    = aws_ecs_task_definition.backend_ecs_task_definition.arn
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100
  depends_on                         = [aws_lb_listener.lb_list_https]

  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend_lb_tg.arn
    container_name   = "backend-container"
    container_port   = 80
  }
}


resource "aws_ecs_task_definition" "backend_ecs_task_definition" {
  family                   = "backend-service"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = aws_iam_role.backend_ecs_instance_role.arn
  container_definitions = jsonencode([
    {
      name                   = "backend-container"
      image                  = var.backend_ecr_repository_url
      cpu                    = 1792
      memory                 = 3456
      essential              = true
      privileged             = false
      readonlyRootFilesystem = false
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
          hostPort      = var.host_port
        }
      ]
      #logConfiguration = {
      #  logDriver = "awslogs"
      #  options = {
      #    awslogs-group  = ""
      #    awslogs-region = ""
      #  }
      #}
      environment = [
        {
          name  = "Environment"
          value = "dev"
        },
        {
          name  = "Region"
          value = "us-east-1"
        }
      ]
      #links    = [""]
      #hostname = ""
    }
  ])
}

resource "aws_security_group" "backend_ecs_sg" {
  name_prefix = var.sg_name_prefix
  vpc_id      = aws_vpc.backend_vpc.id

  ingress {
    from_port   = var.ingress_port_range.from
    to_port     = var.ingress_port_range.to
    protocol    = var.ingress_protocol
    cidr_blocks = var.ingress_cidr_blocks
  }

  egress {
    from_port   = var.egress_port_range.from
    to_port     = var.egress_port_range.to
    protocol    = var.egress_protocol
    cidr_blocks = var.egress_cidr_blocks
  }

  tags = var.sg_tags
}

resource "aws_iam_role" "backend_ecs_instance_role" {
  name = "ecs-instance-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "backend_ecs_instance_profile" {
  name = "ecs-instance-profile"
  role = aws_iam_role.backend_ecs_instance_role.name
}

resource "aws_launch_configuration" "backend_ecs_lc" {
  name_prefix                 = "ecs-launch-config-"
  image_id                    = var.ami_id
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.backend_ecs_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.backend_ecs_instance_profile.name
  associate_public_ip_address = true
  #user_data                   = file("userdata.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "backend_ecs_asg" {
  name                      = "ecs-asg"
  vpc_zone_identifier       = [aws_subnet.backend_public_a.id]
  launch_configuration      = aws_launch_configuration.backend_ecs_lc.name
  min_size                  = 1
  max_size                  = 1
  health_check_grace_period = 300
  target_group_arns         = [aws_lb_target_group.backend_lb_tg.arn]

  tag {
    key                 = "Name"
    value               = "ecs-autoscaling-group"
    propagate_at_launch = true
  }
}


resource "aws_lb" "backend_lb" {
  name               = "backend-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.backend_lb_sg.id]
  subnet_mapping {
    subnet_id = aws_subnet.backend_public_a.id
  }
  subnet_mapping {
    subnet_id = aws_subnet.backend_public_b.id
  }
  enable_deletion_protection = false
}


resource "aws_lb_target_group" "backend_lb_tg" {
  name             = "backend-lb-tg"
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  target_type      = "instance"
  vpc_id           = aws_vpc.backend_vpc.id
  health_check {
    healthy_threshold   = "5"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "5"
    path                = "/api/status"
    unhealthy_threshold = "5"
  }
}

resource "aws_lb_listener" "lb_list_http" {
  load_balancer_arn = aws_lb.backend_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "lb_list_https" {
  load_balancer_arn = aws_lb.backend_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:609536296551:certificate/f6c2cb50-6842-4c86-a0ee-2665a58b5265"
  default_action {
    target_group_arn = aws_lb_target_group.backend_lb_tg.arn
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "https_rule" {
  listener_arn = aws_lb_listener.lb_list_https.arn
  priority     = 1
 
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_lb_tg.arn
  }

  condition {
    host_header {
      values = [""]
    }
  }
}

resource "aws_security_group" "backend_lb_sg" {
  name   = "vlgx-alb-sg"
  vpc_id = aws_vpc.backend_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
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



