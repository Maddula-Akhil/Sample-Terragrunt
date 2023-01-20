resource "aws_db_instance" "rds" {
  identifier            = local.rds_instance_identifier
  db_name               = local.rds_primary_db_name
  engine                = local.rds_engine
  engine_version        = local.rds_engine_version
  instance_class        = local.rds_instance_class
  username              = local.rds_username
  password              = local.rds_password
  allocated_storage     = 20
  max_allocated_storage = 100
  maintenance_window    = "Thu:04:41-Thu:05:11"
  storage_type          = "gp3"
  db_subnet_group_name  = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_dev_sg.id]
  availability_zone     = var.subnet_a_az # reference to primary AZ
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${local.app_name}_${local.env}_db_subnet_group"
  subnet_ids = [] # Add reference to private subnets to keep the RDS Instance away from internet access
}

resource "aws_security_group" "rds_sg" {
  name   = local.rds-security-group-name
  vpc_id = "" # Reference to self-created VPC 

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [] # Preferably allow security group of Application server / Bastion host to access RDS
  }
}