terraform {
  source = "git::https://github.com/Promact/devops-templates.git/terragrunt"
}



inputs = {
  aws_instance       = "prod-instances"
  instance_type      = "t2.micro"
  app_name           = "prod"
  aws_security_group = "prod-sg"
  region             = "us-west-1"
  subnet_a_az        = "us-west-1a"
  ami                = "ami-09c5c62bac0d0634e"
}
