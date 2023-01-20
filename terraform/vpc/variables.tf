variable "region" {}
variable "account_id" {}
variable "subnet_a_az" {}
variable "subnet_b_az" {}
variable "subnet_c_az" {}

locals {
  app_name                          = "" # Application identifier
  vpc_cidr                          = "10.0.0.0/16"
  public_subnet_a_cidr              = "10.0.0.0/19"
  private_subnet_a_cidr             = "10.0.32.0/19"
  public_subnet_b_cidr              = "10.0.64.0/19"
  private_subnet_b_cidr             = "10.0.96.0/19"
  public_subnet_c_cidr              = "10.0.128.0/19"
  private_subnet_c_cidr             = "10.0.160.0/19"
}