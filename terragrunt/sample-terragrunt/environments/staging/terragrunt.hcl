terraform {
  source = "git::https://github.com/Promact/devops-templates.git/terragrunt"
}

inputs = {
  aws_instance       = "staging-instances"
  instance_type      = "t2.large"
  app_name           = "staging"
  aws_security_group = "staging-sg"
  region             = "ap-south-1"
  subnet_a_az        = "ap-south-1a"
  ami                = "ami-07d3a50bd29811cd1"
}
