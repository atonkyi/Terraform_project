resource "aws_autoscaling_group" "web" {
  name                      = "WebServer-Highly-Availible-ALB-Ver-${aws_launch_template.web.latest_version}"
  max_size                  = 4
  desired_capacity          = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"

  force_delete        = true
  vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  target_group_arns   = [aws_lb_target_group.web.arn]

  launch_template {
    id      = aws_launch_template.web.id
    version = aws_launch_template.web.latest_version
  }

  #Устанавливаем, что бы не было down time
  lifecycle {
    create_before_destroy = true
  }

  dynamic "tag" {
    for_each = {
      "Name" = "WebServer in AGS - ${aws_launch_template.web.latest_version}"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}


resource "aws_lb" "web" {
  name               = "WebServer-Highly-Availible-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ec2_sg.id]
  subnets            = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]

  tags = var.common_tags
}


resource "aws_lb_target_group" "web" {
  name                 = "WebServer-Highly-Availible-TG"
  vpc_id               = aws_default_vpc.default_vpc.id
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 10 #secpnds
}


resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}
