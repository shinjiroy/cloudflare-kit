locals {
  environment         = "production"
  short_environment   = "prod"
  state_bucket        = "hoge-state"
  # state_bucket_region = "ap-northeast-1" # S3に保存するならこっち
  state_bucket_region = "ap-northeast-1a"
}
