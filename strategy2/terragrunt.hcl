locals {
  account_id = "123456789" # ドメイン共通かつ直書きで良いだろう。嫌な場合はTF_VAR_account_id環境変数なりで対応

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
#     region  = "ap-northeast-1"
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
#     region                      = "ap-northeast-1a" # autoでも良さそう
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
