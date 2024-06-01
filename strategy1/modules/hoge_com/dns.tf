# 全て、オリジンがCloudflare管轄かどうかで内容が変わります。

# ドメイン用レコード
resource "cloudflare_record" "www" {
  name    = "www"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = var.www_hoge_com_origin_host
  zone_id = cloudflare_zone.zone.id
}

# オリジン切り替え指定用レコード
resource "cloudflare_record" "origin_static" {
  name    = "origin-static"
  proxied = false # 例えばS3で、静的ウェブサイトホスティングならtrue
  ttl     = 1
  type    = "CNAME"
  value   = var.static_origin_host
  zone_id = cloudflare_zone.zone.id
}
