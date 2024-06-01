include "root" {
  path   = find_in_parent_folders("terragrunt.hcl")
  expose = true
}

terraform {
  source = "../../modules//hoge_com"
}

locals {
  root_vars         = include.root.locals
  environment       = local.root_vars.environment
  short_environment = local.root_vars.short_environment
  service_name      = local.root_vars.service_name
  module_name       = local.root_vars.module_name
  account_id        = local.root_vars.account_id
}

inputs = {
  environment       = local.environment
  short_environment = local.short_environment
  service_name      = local.environment
  account_id        = local.account_id

  hoge_com_domain_name     = "hoge.com"
  www_hoge_com_origin_host = "origin.hoge.com"
  static_origin_host       = "origin.static.com"
}
