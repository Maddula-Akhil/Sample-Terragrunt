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

A Virtual Private Cloud (VPC) is a private, isolated network within the AWS cloud. The VPC created by these Terraform templates includes three public and three private subnets. The public subnets are used for resources that need to be accessible from the internet, such as load balancers, while the private subnets are used for resources that should not be accessible from the internet, such as databases.

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

Amazon Elastic Compute Cloud (EC2) is a web service that provides resizable compute capacity in the cloud. In this infrastructure, an EC2 instance is used for the backend of the application. The EC2 instance is launched in one of the private subnets created in the VPC, ensuring that it is not directly accessible from the internet.

### Variables

- `ami`: Default = "ami-06e46074ae430fba6"
- `instance_type`: Default = "t2.micro"
- `key_name`: Default = ""
- `instance_name`: Default = "ec2-instance"
- `volume_size`: Default = "8"
- `terraform_version`: Default = "v1.0.6"
- `terragrunt_version`: Default = "v0.34.1"
- `ingress_rules`: Default from_port   = 22, Default to_port     = 22,  Default protocol    = "tcp", cidr_blocks = ["0.0.0.0/0"]
## Relational Database Service (RDS)

Amazon Relational Database Service (RDS) is a web service that makes it easier to set up, operate, and scale a relational database in the cloud. In this infrastructure, an RDS instance is used for storing and accessing the application's data. The RDS instance is launched in one of the private subnets created in the VPC, ensuring that it is not directly accessible from the internet.

### Variables

- `db_instance_identifier`: Default = "db"
- `db_allocated_storage`: Default = "20"
- `db_engine`: Default = "mysql"
- `db_engine_version`: Default = "8.0"
- `db_instance_class`: Default = "db.t2.micro"
- `db_name`: Default = "db"
- `db_username`: Default = ""
- `db_password`: Default = ""
- `db_multi_az`: Default = "false"
- `db_skip_final_snapshot`: Default = "true"
- `db_tags`: Default terraform_version = "v1.0.6" , Default terragrunt_version = "v0.34.1"
- `db_backup_retention_period`: Default = "7"
- `db_copy_tags_to_snapshot`: Default = "true"
- `db_publicly_accessible`: Default = "false"
- `cidr_blocks`: Default = "["10.0.0.0/16"]"
- `from_port`: Default = "0"
- `to_port`: Default = "0"
- `protocol`: Default = "-1"
- `allowed_ports`: Default = "[3306]"
- `allowed_cidr_blocks`: Default = "["0.0.0.0/0"]"
- `subnet_group_name`: Default = "db-subnet-group"
## AWS Simple Storage Service (S3) - Storage

In addition to hosting the frontend of the application, an S3 bucket is also used for storing data files such as images, documents, and other assets. This S3 bucket is configured to store data files securely and is accessible only to authorized users.

### Variables

- `private_bucket_1_name`: Default = "storage-bucket-promact"
- `terraform_version`: Default = "v1.0.6"
- `terragrunt_version`: Default = "v0.34.1"

## AWS Simple Storage Service (S3) - Site Hosting

Amazon Simple Storage Service (S3) is an object storage service that offers industry-leading scalability, data availability, security, and performance. In this infrastructure, an S3 bucket is used for hosting the frontend of the application as a static website. The S3 bucket is configured to serve static content over HTTPS.

### Variables

- `private_bucket_2_name`: Default = "static-site-bucket-promact"
- `terraform_version`: Default = "v1.0.6"
- `terragrunt_version`: Default = "v0.34.1"

## AWS Cloudfront (CDN)

Amazon CloudFront is a fast content delivery network (CDN) service that securely delivers data, videos, applications, and APIs to customers globally with low latency, high transfer speeds, all within a developer-friendly environment. In this infrastructure, a CDN is created in front of the S3 bucket used for hosting the frontend of the application. The CDN improves the performance of the frontend by caching content at edge locations around the world, reducing the time it takes for users to load the site

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
