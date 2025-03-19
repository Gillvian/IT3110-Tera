resource "aws_launch_configuration" "this" {
  name_prefix   = "techNova-lc-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = file("${path.module}/user-data.sh")
  security_groups = [aws_security_group.this.id]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  desired_capacity     = var.instance_count
  max_size             = var.instance_count + 1
  min_size             = var.instance_count - 1
  vpc_zone_identifier  = var.subnet_ids
  launch_configuration = aws_launch_configuration.this.id
  target_group_arns    = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "techNova-ec2"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_security_group" "this" {
  vpc_id = var.vpc_id
  tags   = var.tags
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
