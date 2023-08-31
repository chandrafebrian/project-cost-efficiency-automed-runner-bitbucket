include "root" {
  path = find_in_parent_folders()
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl")).locals
  Name = "vm-spot-runner-preproduction-1"
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules/ec2_runner_spot_ubuntu"
}

inputs = {
  instance_name            = local.Name
  instance_type            = "m6a.xlarge"
  public_subnets           = local.env_vars.vpc_sg
  vpc_security_group_ids   = [local.env_vars.sg_nomad_sg]
  availability_zone        = "your-region"
  lb_security_group        = local.env_vars.gateway-sg
  
  var_tags = {
    "environment"       = ""
    "business-unit"     = ""
    "team"              = ""
    "type"              = "runner"
    "component"         = "bitbucket"
    "lifecycle"         = "spot"
    "instance_type"     = "m6a.xlarge"
    "resource_cpu"      = "4vCPU"
    "resource_memory"   = "16GB"
    "Name"              = local.Name
  }
}