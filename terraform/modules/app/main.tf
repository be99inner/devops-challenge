locals {
  name_prefix = var.name_prefix
  common_tags = merge(var.tags, {
    Module = "app"
  })
  active_tg_arn = var.active_deployment == "blue" ? aws_lb_target_group.blue.arn : aws_lb_target_group.green.arn
}

# IAM Role for EC2 instances
resource "aws_iam_role" "ec2_role" {
  name = "${local.name_prefix}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "additional_policies" {
  for_each   = toset(var.additional_iam_policies)
  role       = aws_iam_role.ec2_role.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${local.name_prefix}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# Launch Template
resource "aws_launch_template" "app" {
  name_prefix   = "${local.name_prefix}-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_profile.arn
  }

  user_data = base64encode(var.user_data)

  vpc_security_group_ids = var.security_groups

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.common_tags, {
      Name = "${local.name_prefix}-instance"
    })
  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(local.common_tags, {
      Name = "${local.name_prefix}-volume"
    })
  }

  tags = local.common_tags
}

# Target Groups
resource "aws_lb_target_group" "blue" {
  name        = "${local.name_prefix}-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(local.common_tags, {
    Color = "blue"
  })
}

resource "aws_lb_target_group" "green" {
  name        = "${local.name_prefix}-green"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(local.common_tags, {
    Color = "green"
  })
}

# Application Load Balancer
resource "aws_lb" "app" {
  name               = "${local.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-alb"
  })
}

resource "aws_security_group" "alb" {
  name_prefix = "${local.name_prefix}-alb-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

# Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = local.active_tg_arn
  }
}

# Auto Scaling Groups
resource "aws_autoscaling_group" "blue" {
  name = "${local.name_prefix}-blue-asg"
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  min_size         = var.blue_min_size
  max_size         = var.blue_max_size
  desired_capacity = var.blue_desired_capacity

  vpc_zone_identifier = var.private_subnet_ids

  target_group_arns = [aws_lb_target_group.blue.arn]

  tag {
    key                 = "Name"
    value               = "${local.name_prefix}-blue"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  tag {
    key                 = "Color"
    value               = "blue"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "green" {
  name = "${local.name_prefix}-green-asg"
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  min_size         = var.green_min_size
  max_size         = var.green_max_size
  desired_capacity = var.green_desired_capacity

  vpc_zone_identifier = var.private_subnet_ids

  target_group_arns = [aws_lb_target_group.green.arn]

  tag {
    key                 = "Name"
    value               = "${local.name_prefix}-green"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  tag {
    key                 = "Color"
    value               = "green"
    propagate_at_launch = true
  }
}