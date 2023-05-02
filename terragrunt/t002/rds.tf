variable "db_instance_identifier" {
  type        = string
  description = " A string representing the identifier for the RDS instance. The default value is backenddb"
  default     = "backenddb"
}

variable "db_allocated_storage" {
  type        = number
  description = "A number representing the amount of storage in gigabytes to be allocated for the RDS instance. The default value is 20"
  default     = 20
}

variable "db_engine" {
  type        = string
  description = "A string that represents the database engine to be used for the instance. The default value is mysql"
  default     = "mysql"
}

variable "db_engine_version" {
  type        = string
  description = "A string that represents the version of the database engine to be used for the instance. The default value is '8.0'"
  default     = "8.0"
}

variable "db_instance_class" {
  type        = string
  description = "A string that represents the instance class to be used for the database instance. The default value is db.t2.micro"
  default     = "db.t2.micro"
}

variable "db_name" {
  type        = string
  description = "A string that represents the name of the database to be created on the instance. The default value is backenddb"
  default     = "backenddb"
}

variable "db_username" {
  type        = string
  description = "A string that represents the username that will be used to access the database instance"
  default     = "admin"
}

variable "db_password" {
  type        = string
  description = "A string that represents the password that will be used to access the database instance"
  default     = "password"
}

variable "db_multi_az" {
  type        = bool
  description = " A boolean that represents whether or not the instance should be deployed in multiple availability zones. The default value is false"
  default     = false
}

variable "db_skip_final_snapshot" {
  type        = bool
  description = "A boolean that represents whether or not to skip the creation of a final snapshot before deleting the instance. The default value is true"
  default     = true
}

variable "db_tags" {
  type        = map(string)
  description = "A map of tags to assign to the RDS instance."
  default = {
    "terraform_version"  = "v1.0.6"
    "terragrunt_version" = "v0.34.1"
  }
}

variable "db_backup_retention_period" {
  type        = number
  description = "A number that represents the number of days to retain automated backups. The default value is 7"
  default     = 7
}

variable "db_copy_tags_to_snapshot" {
  type        = bool
  description = " A boolean that represents whether or not to copy the instance tags to the final snapshot. The default value is true"
  default     = true
}

variable "db_publicly_accessible" {
  type        = bool
  description = "A boolean that represents whether or not the database instance should be publicly accessible. The default value is false"
  default     = false
}

variable "cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks to allow access to the security group"
  default     = ["10.0.0.0/16"]
}

variable "from_port" {
  type        = number
  description = "Starting port of the ingress rule"
  default     = 0
}

variable "to_port" {
  type        = number
  description = "Ending port of the ingress rule"
  default     = 0
}

variable "protocol" {
  type        = string
  description = "Protocol of the ingress rule"
  default     = "-1"
}

variable "allowed_ports" {
  type        = list(number)
  description = "List of allowed ports in the ingress rule"
  default     = [3306]
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "List of allowed CIDR blocks in the ingress rule"
  default     = ["0.0.0.0/0"]
}

variable "subnet_group_name" {
  type        = string
  description = "Name of the subnet group"
  default     = "backend-db-subnet-group"
}

#variable "db_parameter_group_name" {
#  type    = string 
#  default = ""
#}
#
#variable "db_preferred_backup_window" {
#  type    = string 
#  default = "22:00-23:00"
#}
#
#variable "db_preferred_maintenance_window" {
#  type    = string 
#  default = "sun:03:00-sun:04:00"
#}
#
#variable "db_storage_encrypted" {
#  type    = bool
#  default = true
#}

#variable "db_kms_key_id" {
#  type    = string 
#  default = ""
#}



# Resources

resource "aws_security_group" "backend_rds_sg" {
  name_prefix = "backend-rds-sg"
  vpc_id      = aws_vpc.backend_vpc.id

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
    Name = "backend-rds-sg"
  }
}

resource "aws_db_subnet_group" "backend_db_subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = [aws_subnet.backend_private_a.id, aws_subnet.backend_private_b.id, aws_subnet.backend_private_c.id]

  tags = {
    Name = "backend-db-subnet-group"
  }
}


resource "aws_db_instance" "backend_db_instance" {
  identifier              = var.db_instance_identifier
  allocated_storage       = var.db_allocated_storage
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  name                    = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.backend_db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.backend_rds_sg.id]
  multi_az                = var.db_multi_az
  skip_final_snapshot     = var.db_skip_final_snapshot
  tags                    = var.db_tags
  backup_retention_period = var.db_backup_retention_period
  copy_tags_to_snapshot   = var.db_copy_tags_to_snapshot
  #db_parameter_group_name   = aws_db_parameter_group.db_parameter_group.name
  #preferred_backup_window   = var.db_preferred_backup_window
  #preferred_maintenance_window = var.db_preferred_maintenance_window
  #storage_encrypted         = var.db_storage_encrypted
  #kms_key_id                = var.db_kms_key_id
  publicly_accessible = var.db_publicly_accessible
}



#resource "aws_db_parameter_group" "db_parameter_group" {
#  name        = "db-parameter-group"
#  family      = "mysql8.0"
#  description = "database parameter group"
#  parameters = {
#}
