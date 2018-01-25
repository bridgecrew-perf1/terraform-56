terraform {
  required_version  = "0.9.8"
}

/*
Launch configuration
*/
resource "aws_launch_configuration" "mod" {
  count                       = "${var.create_asg}"
  name                        = "${var.asg_name}.${var.name}.${count.index}"
  image_id                    = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${var.instance_iam_role}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${var.security_groups}"]
  associate_public_ip_address = "${var.associate_public_ip_address}"
  user_data                   = "${var.user_data}"
  enable_monitoring           = "${var.enable_monitoring}"
  # placement_tenancy           = "${var.placement_tenancy}"
  ebs_optimized               = "${var.ebs_optimized}"
  ebs_block_device            = "${var.ebs_block_device}"
  root_block_device           = "${var.root_block_device}"
  lifecycle {
    create_before_destroy     = true
  }
  # spot_price                  = "${var.spot_price}"  # placement_tenancy does not work with spot_price
}

/*
Auto Scaling group configuration
*/

resource "aws_autoscaling_group" "mod" {
  count = "${var.create_asg}"
  name                        = "${var.asg_name}.${var.name}.${count.index}"
  launch_configuration        = "${aws_launch_configuration.mod.id}"
  vpc_zone_identifier         = ["${var.vpc_zone_identifier}"]
  max_size                    = "${var.max_size}"
  min_size                    = "${var.min_size}"
  desired_capacity            = "${var.desired_capacity}"
  # load_balancers              = ["${var.load_balancers}"]
  # health_check_grace_period   = "${var.health_check_grace_period}"
  # health_check_type           = "${var.health_check_type}"
  # min_elb_capacity            = "${var.min_elb_capacity}"
  # wait_for_elb_capacity       = "${var.wait_for_elb_capacity}"
  # target_group_arns           = ["${var.target_group_arns}"]
  default_cooldown            = "${var.default_cooldown}"
  force_delete                = "${var.force_delete}"
  termination_policies        = "${var.termination_policies}"
  # suspended_processes         = "${var.suspended_processes}"
  # placement_group             = "${var.placement_group}"
  enabled_metrics             = ["${var.enabled_metrics}"]
  wait_for_capacity_timeout   = "${var.wait_for_capacity_timeout}"
  protect_from_scale_in       = "${var.protect_from_scale_in}"
  tags = [
    {
      key                 = "Name"
      value               = "${var.name}.asg.${count.index}"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "${var.tag_project}"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "${var.tag_env}"
      propagate_at_launch = true
    },,
    {
      key                 = "awsCostCenter"
      value               = "${var.tag_costcenter}"
      propagate_at_launch = true
    },,
    {
      key                 = "CreatedBy"
      value               = "${var.tag_createdby}"
      propagate_at_launch = true
    },
  ]
}





















