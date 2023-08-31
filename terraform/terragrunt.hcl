locals {
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region   = local.region_vars.locals.aws_region
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terragrunt-state-${local.aws_region}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.aws_region}"
    dynamodb_table = "terragrunt-state-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
