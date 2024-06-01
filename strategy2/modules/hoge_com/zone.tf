resource "cloudflare_zone" "zone" {
  account_id = var.account_id
  paused     = false
  plan       = "enterprise" # 適宜変更してください
  type       = "partial"
  zone       = "hoge.com"
}

# cloudflare_zone_settings_overrideも必要に応じて管理する
