# 全て、オリジンがCloudflare管轄かどうかで内容が変わります。

# 本番ドメイン用レコード
resource "cloudflare_record" "www" {
  name    = "www"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "origin.hoge.com"
  zone_id = cloudflare_zone.zone.id
}

# 検証用ドメイン用レコード
resource "cloudflare_record" "test" {
  name    = "test"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "origin.test.hoge.com"
  zone_id = cloudflare_zone.zone.id
}

# オリジン切り替え指定用レコード
resource "cloudflare_record" "origin_static" {
  name    = "origin-static"
  proxied = false # 例えばS3で、静的ウェブサイトホスティングならtrue
  ttl     = 1
  type    = "CNAME"
  value   = "origin.static.com"
  zone_id = cloudflare_zone.zone.id
}

resource "cloudflare_record" "origin_static_test" {
  name    = "origin-static-test"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "origin.test.static.com"
  zone_id = cloudflare_zone.zone.id
}
