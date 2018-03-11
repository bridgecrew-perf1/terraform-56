terraform {
  required_version  = "> 0.9.8"
}

resource "aws_autoscaling_group" "main" {
  count                       = "${var.count}"
  name                        = "${var.name}.${count.index}.as"
  launch_configuration        = "${var.launch_configuration}"
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
      value               = "${var.name}.${count.index}.as"
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




















