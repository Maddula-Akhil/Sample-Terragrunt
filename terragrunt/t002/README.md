# Resources

![AWS](https://img.shields.io/badge/AWS-Amazon%20Web%20Services-orange)
![Terraform](https://img.shields.io/badge/Terraform-v1.0.6-brightgreen)
![Terragrunt](https://img.shields.io/badge/Terragrunt-v0.34.1-blue)

## Project Title

Description of the project.

This repository contains the following resources that are provisioned and managed using AWS, Terraform, and Terragrunt:

1. AWS VPC with 3 public and 3 private subnets 
2. ECS Cluster - Backend
3. S3 - Static site hosting
4. Cloudfront - CDN with S3 Static site
5. S3 - Storage
6. RDS

## AWS VPC with 3 public and 3 private subnets

The AWS VPC (Virtual Private Cloud) is a virtual network that you can use to isolate your infrastructure in the cloud. The VPC in this template has 3 public subnets and 3 private subnets, which can be used to host your applications and services. The public subnets are used for resources that need to be accessible from the internet, while the private subnets are used for resources that should not be directly accessible from the internet.

### Variables

- `region`: Default = "us-east-1"
- `backend_subnet_a_az`: Default = "us-east-1a"
- `backend_subnet_b_az`: Default = "us-east-1b"
- `backend_subnet_c_az`: Default = "us-east-1c"
- `backend_app_name`: Default = "backend"
- `backend_env`: Default = ""
- `backend_vpc_cidr`: Default = "10.1.0.0/16"
- `backend_public_subnet_a_cidr`: Default = "10.1.0.0/19"
- `backend_private_subnet_a_cidr`: Default = "10.1.32.0/19"
- `backend_public_subnet_b_cidr`: Default = "10.1.64.0/19"
- `backend_private_subnet_b_cidr`: Default = "10.1.96.0/19"
- `backend_public_subnet_c_cidr`: Default = "10.1.128.0/19"
- `backend_private_subnet_c_cidr`: Default = "10.1.160.0/19"
- `terraform_version`: Default = "v1.0.6"
- `terragrunt_version`: Default = "v0.34.1"

## ECS Cluster - Backend

The ECS (Elastic Container Service) cluster is used to run containerized applications in the cloud. In this template, the ECS cluster is used as the backend for your applications. You can use this cluster to deploy and run your application containers.

### Variables

- `aws_region`: Default = "us-east-1"
- `ecs_cluster_name`: Default = "backend-cluster"
- `ami_id`: Default = "ami-02396cdd13e9a1257"
- `instance_type`: Default = t2.micro"
- `backend_ecr_repository_url`: Default = ""
- `container_port`: Default = 80""
- `host_port`: Default = "80"
- `sg_name_prefix`: Default = "backend"
- `ingress_port_range`: Default = "{ from = 0, to = 65535 }"
- `ingress_protocol`: Default = "tcp"
- `ingress_cidr_blocks`: Default = "["0.0.0.0/0"]"
- `egress_port_range`: Default = "{ from = 0, to = 0 }"
- `egress_protocol`: Default = "1"
- `egress_cidr_blocks`: Default = "["0.0.0.0/0"]"
- `sg_tags`: Default = "{ Name = "ecs-sg" }"
- `terraform_version`: Default = "v1.0.6"
- `terragrunt_version`: Default = "v0.34.1"

## S3 - Storage

The S3 bucket is also used as a storage service for your application data. You can use this bucket to store your application data, such as user files, backups, logs, etc.

### Variables

- `private_bucket_1_name`: Default = "storage-bucket-backend-promact"
- `terraform_version`: Default = "v1.0.6"
- `terragrunt_version`: Default = "v0.34.1"


## S3 - Static site hosting

The S3 (Simple Storage Service) is a storage service that can be used to store and retrieve data from the cloud. In this template, the S3 bucket is used for hosting your static website. You can upload your website files to the S3 bucket, and it will be served as a static website.

### Variables

- `private_bucket_2_name`: Default = "static-site-bucket-backend-promact"
- `terraform_version`: Default = "v1.0.6"
- `terragrunt_version`: Default = "v0.34.1"

## AWS Cloudfront (CDN)

Amazon CloudFront is a fast content delivery network (CDN) service that securely delivers data, videos, applications, and APIs to customers globally with low latency, high transfer speeds, all within a developer-friendly environment. In this infrastructure, a CDN is created in front of the S3 bucket used for hosting the frontend of the application. The CDN improves the performance of the frontend by caching content at edge locations around the world, reducing the time it takes for users to load the site


## RDS

The RDS (Relational Database Service) is a managed database service that can be used to host your databases in the cloud. In this template, the RDS is used as the database service for your applications. You can use this service to host your application databases, such as MySQL, PostgreSQL, etc.

### Variables

- `db_instance_identifier`: Default = "backenddb"
- `db_allocated_storage`: Default = "20"
- `db_engine`: Default = "mysql"
- `db_engine_version`: Default = "8.0"
- `db_instance_class`: Default = "db.t2.micro"
- `db_name`: Default = "backenddb"
- `db_username`: Default = ""
- `db_password`: Default = ""
- `db_multi_az`: Default = "false"
- `db_skip_final_snapshot`: Default = "true"
- `db_tags`: Default = "{terraform_version  = v1.0.6, terragrunt_version = v0.34.1}"
- `db_backup_retention_period`: Default = "7"
- `db_copy_tags_to_snapshot`: Default = "true"
- `db_publicly_accessible`: Default = "false"
- `cidr_blocks`: Default = "["10.0.0.0/16"]"
- `from_port`: Default = "0"
- `to_port`: Default = "0"
- `protocol`: Default = "-1"
- `allowed_ports`: Default = "[3306]"
- `allowed_cidr_blocks`: Default = "["0.0.0.0/0"]"
- `subnet_group_name`: Default = "backend-db-subnet-group"

## Prerequisites

To use these Terraform templates, you will need the following installed on your local machine:

- Terraform >= 1.0
- AWS CLI

## Usage

To use these Terraform templates, follow these steps:

- Clone this repository to your local machine.
- Navigate to the folder containing the Terraform templates in your terminal.
- Run `terraform init` to initialize Terraform.
- Run `terraform plan` to see a preview of the changes Terraform will make.
- Run `terraform apply` to apply the changes and create the AWS infrastructure.

## Cleanup

To destroy the AWS infrastructure created by these Terraform templates, run `terraform destroy`.

