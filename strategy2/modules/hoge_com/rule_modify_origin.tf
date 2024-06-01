resource "cloudflare_ruleset" "modify_origin_rules" {
  kind    = "zone"
  name    = "default"
  phase   = "http_request_origin"
  zone_id = cloudflare_zone.zone.id

  # Ruleは後勝ちなので範囲の広い物から順に書く
  # 本番用を最後に書くようにする。(最初でもいいけれど)
  rules {
    # 静的コンテンツ用パス
    action = "route"
    action_parameters {
      host_header = cloudflare_record.origin_static_test.value # ※S3等の場合、HostヘッダをS3のドメインにしなければならない
      origin {
        host = cloudflare_record.origin_static_test.hostname
      }
    }
    description = "Rule of Static origin for ${cloudflare_record.test.hostname}"
    enabled     = true
    expression  = <<-EOF
    (http.host eq "${cloudflare_record.test.hostname}" and starts_with(http.request.uri.path, "/static/"))
    EOF
  }
  rules {
    # 静的コンテンツ用パス
    action = "route"
    action_parameters {
      host_header = cloudflare_record.origin_static.value # ※S3等の場合、HostヘッダをS3のドメインにしなければならない
      origin {
        host = cloudflare_record.origin_static.hostname
      }
    }
    description = "Rule of Static origin for ${cloudflare_record.www.hostname}"
    enabled     = true
    expression  = <<-EOF
    (http.host eq "${cloudflare_record.www.hostname}" and starts_with(http.request.uri.path, "/static/"))
    EOF
  }
}
