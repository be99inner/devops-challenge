output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnets
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.vpc.igw_id
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways"
  value       = module.vpc.nat_ids
}

output "data_bucket_name" {
  description = "Name of the data S3 bucket"
  value       = module.s3_data.s3_bucket_id
}

output "data_bucket_arn" {
  description = "ARN of the data S3 bucket"
  value       = module.s3_data.s3_bucket_arn
}

output "logs_bucket_name" {
  description = "Name of the logs S3 bucket"
  value       = module.s3_logs.s3_bucket_id
}

output "logs_bucket_arn" {
  description = "ARN of the logs S3 bucket"
  value       = module.s3_logs.s3_bucket_arn
}

output "s3_write_policy_arn" {
  description = "ARN of the IAM policy for S3 write access"
  value       = aws_iam_policy.s3_write_policy.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.app.alb_dns_name
}

output "blue_asg_name" {
  description = "Name of the blue Auto Scaling Group"
  value       = module.app.blue_asg_name
}

output "green_asg_name" {
  description = "Name of the green Auto Scaling Group"
  value       = module.app.green_asg_name
}