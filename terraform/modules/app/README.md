# App Terraform Module

This module creates an AWS Application Load Balancer (ALB) with EC2 instances in Auto Scaling Groups (ASG), supporting blue/green deployments. It includes IAM roles, launch templates, target groups, and the ability to switch traffic between blue and green deployments.

## Features

- Application Load Balancer with HTTP listener
- EC2 instances via Launch Template and Auto Scaling Groups
- IAM role with SSM and CloudWatch policies for instance management and monitoring
- Blue and green target groups for deployment strategies
- Support for blue/green deployment by switching active target group
- Configurable ASG sizes for each deployment color
- Security groups for ALB

## Usage

```hcl
module "app" {
  source = "./modules/app"

  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids

  name_prefix         = "my-app"
  ami_id             = "ami-12345678"
  instance_type      = "t3.micro"
  active_deployment  = "blue"

  blue_min_size         = 1
  blue_max_size         = 3
  blue_desired_capacity = 2

  green_min_size         = 0
  green_max_size         = 3
  green_desired_capacity = 0

  tags = {
    Environment = "prod"
    Application = "my-app"
  }
}
```

## Blue/Green Deployment

To perform a blue/green deployment:

1. Deploy green ASG with new application version
2. Scale green ASG to desired capacity
3. Update `active_deployment` to "green" to switch ALB traffic
4. Verify green deployment is working
5. Scale blue ASG to 0 if needed

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| vpc_id | ID of the VPC | `string` | | yes |
| public_subnet_ids | IDs of the public subnets for ALB | `list(string)` | | yes |
| private_subnet_ids | IDs of the private subnets for EC2 instances | `list(string)` | | yes |
| name_prefix | Prefix for resource names | `string` | `"app"` | no |
| ami_id | AMI ID for EC2 instances | `string` | | yes |
| instance_type | EC2 instance type | `string` | `"t3.micro"` | no |
| key_name | SSH key pair name | `string` | `null` | no |
| blue_min_size | Minimum size for blue ASG | `number` | `1` | no |
| blue_max_size | Maximum size for blue ASG | `number` | `2` | no |
| blue_desired_capacity | Desired capacity for blue ASG | `number` | `1` | no |
| green_min_size | Minimum size for green ASG | `number` | `0` | no |
| green_max_size | Maximum size for green ASG | `number` | `2` | no |
| green_desired_capacity | Desired capacity for green ASG | `number` | `0` | no |
| active_deployment | Active deployment color (blue or green) | `string` | `"blue"` | no |
| tags | Tags to apply to resources | `map(string)` | `{}` | no |
| user_data | User data script for EC2 instances | `string` | `""` | no |
| security_groups | Additional security groups for EC2 instances | `list(string)` | `[]` | no |
| additional_iam_policies | Additional IAM policy ARNs to attach to the EC2 role | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb_dns_name | DNS name of the Application Load Balancer |
| alb_arn | ARN of the Application Load Balancer |
| blue_target_group_arn | ARN of the blue target group |
| green_target_group_arn | ARN of the green target group |
| active_target_group_arn | ARN of the currently active target group |
| blue_asg_name | Name of the blue Auto Scaling Group |
| green_asg_name | Name of the green Auto Scaling Group |
| iam_role_arn | ARN of the IAM role for EC2 instances |
| launch_template_id | ID of the launch template |
