output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app.dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.app.arn
}

output "blue_target_group_arn" {
  description = "ARN of the blue target group"
  value       = aws_lb_target_group.blue.arn
}

output "green_target_group_arn" {
  description = "ARN of the green target group"
  value       = aws_lb_target_group.green.arn
}

output "active_target_group_arn" {
  description = "ARN of the currently active target group"
  value       = local.active_tg_arn
}

output "blue_asg_name" {
  description = "Name of the blue Auto Scaling Group"
  value       = aws_autoscaling_group.blue.name
}

output "green_asg_name" {
  description = "Name of the green Auto Scaling Group"
  value       = aws_autoscaling_group.green.name
}

output "iam_role_arn" {
  description = "ARN of the IAM role for EC2 instances"
  value       = aws_iam_role.ec2_role.arn
}

output "launch_template_id" {
  description = "ID of the launch template"
  value       = aws_launch_template.app.id
}