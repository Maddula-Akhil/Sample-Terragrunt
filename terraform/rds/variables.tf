variable "aws_region" {}

locals {

  # RDS

  rds_instance_identifier = ""
  rds_primary_db_name     = ""
  rds_engine              = "postgres"     # Use Postgres unless specified otherwise
  rds_engine_version      = "14"           # Use latest available unless legacy required
  rds_instance_class      = "db.t4g.micro" # Use free tier unless specifics required
  rds_username            = ""             # Master username
  rds_password            = ""             # Master Password

  # RDS Security Group

  rds_security_group_name = ""

}
