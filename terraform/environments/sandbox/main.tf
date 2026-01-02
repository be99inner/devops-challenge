module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.environment}-vpc"
  cidr = var.vpc_cidr

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = var.tags
}

# Data source for latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

module "app" {
  source = "../../modules/app"

  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnets
  private_subnet_ids = module.vpc.private_subnets

  name_prefix = var.environment
  ami_id      = data.aws_ami.amazon_linux.id

  # Blue/green with blue active
  active_deployment      = "blue"
  blue_desired_capacity  = 1
  green_desired_capacity = 0

  additional_iam_policies = [aws_iam_policy.s3_write_policy.arn]

  tags = var.tags
}

# S3 Buckets
resource "random_id" "s3_suffix" {
  byte_length = 16
}

module "s3_data" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket = "${var.environment}-data-bucket-${random_id.s3_suffix.dec}"

  tags = merge(var.tags, {
    Name = "${var.environment}-data-bucket-${random_id.s3_suffix.dec}"
    Type = "data"
  })
}

module "s3_logs" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket = "${var.environment}-logs-bucket-${random_id.s3_suffix.dec}"

  versioning = {
    enabled = true
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-logs-bucket-${random_id.s3_suffix.dec}"
    Type = "logs"
  })
}

# IAM Policy for S3 write access to data and logs buckets
resource "aws_iam_policy" "s3_write_policy" {
  name        = "${var.environment}-s3-write-policy"
  description = "Policy to allow writing objects to data and logs S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "${module.s3_data.s3_bucket_arn}/*",
          "${module.s3_logs.s3_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = "s3:ListBucket"
        Resource = [
          module.s3_data.s3_bucket_arn,
          module.s3_logs.s3_bucket_arn
        ]
      }
    ]
  })

  tags = var.tags
}

