terraform {
  source = "git::https://github.com/Promact/devops-templates.git/terragrunt"
}

inputs = {
  aws_instance       = "dev-instances"
  instance_type      = "t2.micro"
  app_name           = "dev"
  aws_security_group = "dev-sg"
  region             = "us-east-1"
}
