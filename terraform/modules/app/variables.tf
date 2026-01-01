variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of the public subnets for ALB"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "IDs of the private subnets for EC2 instances"
  type        = list(string)
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "app"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = null
}

variable "blue_min_size" {
  description = "Minimum size for blue ASG"
  type        = number
  default     = 1
}

variable "blue_max_size" {
  description = "Maximum size for blue ASG"
  type        = number
  default     = 2
}

variable "blue_desired_capacity" {
  description = "Desired capacity for blue ASG"
  type        = number
  default     = 1
}

variable "green_min_size" {
  description = "Minimum size for green ASG"
  type        = number
  default     = 0
}

variable "green_max_size" {
  description = "Maximum size for green ASG"
  type        = number
  default     = 2
}

variable "green_desired_capacity" {
  description = "Desired capacity for green ASG"
  type        = number
  default     = 0
}

variable "active_deployment" {
  description = "Active deployment color (blue or green)"
  type        = string
  default     = "blue"
  validation {
    condition     = contains(["blue", "green"], var.active_deployment)
    error_message = "Active deployment must be either 'blue' or 'green'."
  }
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "user_data" {
  description = "User data script for EC2 instances"
  type        = string
  default     = ""
}

variable "security_groups" {
  description = "Additional security groups for EC2 instances"
  type        = list(string)
  default     = []
}

variable "additional_iam_policies" {
  description = "Additional IAM policy ARNs to attach to the EC2 role"
  type        = list(string)
  default     = []
}