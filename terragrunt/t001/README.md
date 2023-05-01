# Resources

![AWS](https://img.shields.io/badge/AWS-Amazon%20Web%20Services-orange)
![Terraform](https://img.shields.io/badge/Terraform-v1.0.6-brightgreen)
![Terragrunt](https://img.shields.io/badge/Terragrunt-v0.34.1-blue)

This repository contains the following resources that are provisioned and managed using AWS, Terraform, and Terragrunt:

1. VPC
2. EC2
3. RDS
4. S3 - Storage
5. S3 - Static site hosting
6. Cloudfront - CDN

## AWS VPC

Custom VPC configuration for allowing modifications as required

### Variables

- `app_name`: Default = "New Project"
- `env`: Default = "dev"
- `region`: Default = "us-east-1"
- `subnet_a_az`: Default = "us-east-1a"
- `subnet_b_az`: Default = "us-east-1b"
- `subnet_c_az`: Default = "us-east-1c"
- `vpc_cidr`: Default = "10.0.0.0/16"
- `public_subnet_a_cidr`: Default = "10.0.0.0/19"
- `private_subnet_a_cidr`: Default = "10.0.32.0/19"
- `public_subnet_b_cidr`: Default = "10.0.64.0/19"
- `private_subnet_b_cidr`: Default = "10.0.96.0/19"
- `public_subnet_c_cidr`: Default = "10.0.128.0/19"
- `private_subnet_c_cidr`: Default = "10.0.160.0/19"

## AWS Elastic Compute Cloud (EC2)

Description of resource 2.

### Variables

- `variable_1`: Description of variable 1.
- `variable_2`: Description of variable 2.
- `variable_3`: Description of variable 3.

## Relational Database Service (RDS)

Description of resource 3.

### Variables

- `variable_1`: Description of variable 1.
- `variable_2`: Description of variable 2.
- `variable_3`: Description of variable 3.

## AWS Simple Storage Service (S3) - Storage

Description of resource 3.

### Variables

- `variable_1`: Description of variable 1.
- `variable_2`: Description of variable 2.
- `variable_3`: Description of variable 3.

## AWS Simple Storage Service (S3) - Site Hosting

Description of resource 3.

### Variables

- `variable_1`: Description of variable 1.
- `variable_2`: Description of variable 2.
- `variable_3`: Description of variable 3.

## AWS Cloudfront (CDN)

Description of resource 3.

### Variables

- `variable_1`: Description of variable 1.
- `variable_2`: Description of variable 2.
- `variable_3`: Description of variable 3.