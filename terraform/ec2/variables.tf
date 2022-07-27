variable "aws_region" {}

locals {

  # EC2
  ubuntu-ami-id                = {}   # AMI needs to be in the same region, can be found in AMI Catalog in AWS
  ec2-instance-type            = {}
  ec2-termination-protection   = true
  ec2-cpu-credits              = "unlimited"
  ec2-key-name                 = {}
  ec2-public-ip-flag           = true
  ec2-root-volume-size         = 30
  ec2-volume-delete-on-termination = false

  # Security Groups
  security-group-name          = {}

}
