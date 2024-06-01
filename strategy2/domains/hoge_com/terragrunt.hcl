include "root" {
  path   = find_in_parent_folders("terragrunt.hcl")
  expose = true
}

terraform {
  source = "../../modules//hoge_com"
}

locals {
  root_vars    = include.root.locals
  service_name = local.root_vars.service_name
  module_name  = local.root_vars.module_name
  account_id   = local.root_vars.account_id
}

inputs = {
  service_name = local.environment
  account_id   = local.account_id
}
