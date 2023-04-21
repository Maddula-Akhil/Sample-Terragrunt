variable "db_instance_identifier" {
  type    = string
  default = "db"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}
   
variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_engine_version" {
  type    = string
  default = "8.0"
}

variable "db_instance_class" {
  type    = string
  default = "db.t2.micro"
}

variable "db_name" {
  type    = string
  default = "db"
}

variable "db_username" {
  type    = string
  default = "admin"
}

variable "db_password" {
  type    = string
  default = "password"
}

variable "db_multi_az" {
  type    = bool
  default = false
}

variable "db_skip_final_snapshot" {
  type    = bool
  default = true
}

variable "db_tags" {
  type    = map(string)
  default = {}
}

variable "db_backup_retention_period" {
  type    = number
  default = 7
}

variable "db_copy_tags_to_snapshot" {
  type    = bool
  default = true
}

variable "db_publicly_accessible" {
  type    = bool
  default = false
}

variable "cidr_blocks" {
  description = "List of CIDR blocks to allow access to the security group"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "from_port" {
  description = "Starting port of the ingress rule"
  type        = number
  default     = 0
}

variable "to_port" {
  description = "Ending port of the ingress rule"
  type        = number
  default     = 0
}

variable "protocol" {
  description = "Protocol of the ingress rule"
  type        = string
  default     = "-1"
}

variable "allowed_ports" {
  description = "List of allowed ports in the ingress rule"
  type        = list(number)
  default     = [3306]
}

variable "allowed_cidr_blocks" {
  description = "List of allowed CIDR blocks in the ingress rule"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "subnet_group_name" {
  description = "Name of the subnet group"
  type        = string
  default     = "db-subnet-group"
}


resource "aws_security_group" "rds_security_group" {
  name_prefix = "rds-sg"
  vpc_id      = aws_vpc.primary_vpc.id

  ingress {
    from_port   = var.from_port
    to_port     = var.to_port
    protocol    = var.protocol
    cidr_blocks = var.cidr_blocks
  }

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidr_blocks
    }
  }

  tags = {
    Name = "rds-security-group"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id, aws_subnet.private_c.id]

  tags = {
    Name = "db-subnet-group"
  }
}


resource "aws_db_instance" "db_instance" {
  identifier                = var.db_instance_identifier
  allocated_storage         = var.db_allocated_storage
  engine                    = var.db_engine
  engine_version            = var.db_engine_version
  instance_class            = var.db_instance_class
  name                      = var.db_name
  username                  = var.db_username
  password                  = var.db_password
  db_subnet_group_name      = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids    = [aws_security_group.rds_security_group.id]
  multi_az                  = var.db_multi_az
  skip_final_snapshot       = var.db_skip_final_snapshot
  tags                      = var.db_tags
  backup_retention_period   = var.db_backup_retention_period
  copy_tags_to_snapshot     = var.db_copy_tags_to_snapshot
  #preferred_backup_window   = var.db_preferred_backup_window
  #preferred_maintenance_window = var.db_preferred_maintenance_window
  #kms_key_id                = var.db_kms_key_id
  publicly_accessible       = var.db_publicly_accessible
}



