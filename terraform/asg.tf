resource "aws_launch_configuration" "my_lc" {
  name_prefix          = "${var.stack_name}-ecs-lc"
  image_id             = var.ami
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ecs_ec2_instance_profile.id
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = true
  }
  lifecycle {
    create_before_destroy = true
  }
  security_groups             = [var.sec_group]
  associate_public_ip_address = "true"
  key_name                    = var.key_name
  user_data                   = data.template_file.user_data.rendered
}

resource "aws_autoscaling_group" "my-asg" {
  name                 = "${var.stack_name}-ecs-asg"
  max_size             = 3
  min_size             = 1
  desired_capacity     = 2
  vpc_zone_identifier  = var.subnets
  launch_configuration = aws_launch_configuration.my_lc.name
  health_check_type    = "EC2"
}
