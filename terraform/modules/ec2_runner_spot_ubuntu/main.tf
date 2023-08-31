locals {
  parameter_name = var.parameter_name
}

data "template_file" "user_data_setup_server" {
  template = file("./script/setup.sh")
  vars = {
    dns_local      = "172.x.x.x"
    parameter_name = local.parameter_name
  }
}

resource "aws_spot_instance_request" "spot_instance" {
  wait_for_fulfillment = true
  ami                  = var.ami_id
  spot_price           = var.spot_price
  instance_type        = var.instance_type
  spot_type            = var.spot_type
  # block_duration_minutes = 120
  # count                  = 1
  key_name               = var.instance_keypair
  subnet_id              = var.public_subnets
  tags                   = var.var_tags
  iam_instance_profile   = var.iam_instance_profile
  availability_zone      = var.availability_zone
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data_base64       = base64encode(data.template_file.user_data_setup_server.rendered)

  root_block_device {
    volume_type = "gp3"
    volume_size = var.ebs_root_size
  }

}

resource "aws_ec2_tag" "apply_tag" {
  resource_id = aws_spot_instance_request.spot_instance.spot_instance_id
  for_each    = var.var_tags
  key         = each.key
  value       = each.value
}

variable "bits" { default = "32" }

resource "aws_security_group_rule" "assign_ingress" {
  type              = "ingress"
  from_port         = 54646
  to_port           = 58500
  protocol          = "tcp"
  cidr_blocks       = ["${cidrhost("${aws_spot_instance_request.spot_instance.public_ip}/${var.bits}", 0)}/${var.bits}"]
  security_group_id = var.lb_security_group
  description       = "${var.parameter_name}-${aws_spot_instance_request.spot_instance.private_ip}"
}
