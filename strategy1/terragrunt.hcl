locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  environment         = local.environment_vars.locals.environment
  short_environment   = local.environment_vars.locals.short_environment
  state_bucket        = local.environment_vars.locals.state_bucket
  state_bucket_region = local.environment_vars.locals.state_bucket_region

  # account_idは全て同じか、環境別にするか、ドメイン別にするかが各会社のポリシーに依るだろう。
  # ただ、値自体は直書きで良いだろうが、それも嫌な場合はTF_VAR_account_id環境変数なりで対応する。
  account_id = "123456789"

  service_name = "hogeservice"
  module_name  = "cloudflarecdn"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "cloudflare" {

}

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}
EOF
}

remote_state {
  backend = "local"
  config = {
    path = "${get_parent_terragrunt_dir()}/state/${path_relative_to_include()}/terraform.tfstate"
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# S3に保存するならこっち
# AWSの認証情報が必要
# remote_state {
#   backend = "s3" 
#   config = {
#     encrypt = true
#     region  = local.state_bucket_region
#     bucket  = "hoge-state"
#     key     = "${local.service_name}-${local.module_name}/${path_relative_to_include()}/terraform.tfstate"
#   }
#   generate = {
#     path      = "backend.tf"
#     if_exists = "overwrite_terragrunt"
#   }
# }

# R2に保存するならこちら
# remote_state {
#   backend = "s3" 
#   config = {
#     encrypt                     = true
#     region                      = local.state_bucket_region # autoでも良さそう
#     bucket                      = "hoge-state"
#     key                         = "${local.service_name}-${local.module_name}/${path_relative_to_include()}/terraform.tfstate"
#     skip_credentials_validation = true # AWSの認証情報として検証しないようにする
#     endpoint                    = "https://${local.account_id}.r2.cloudflarestorage.com"
#   }
#   generate = {
#     path      = "backend.tf"
#     if_exists = "overwrite_terragrunt"
#   }
# }
