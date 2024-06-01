resource "cloudflare_ruleset" "cors_response_header" {
  kind    = "zone"
  name    = "default"
  phase   = "http_response_headers_transform"
  zone_id = cloudflare_zone.zone.id

  # Ruleは後勝ちなので範囲の広い物から順に書く
  # もしヘッダの値を動的にしたいならばWorkerでやる事になります。
  rules {
    action = "rewrite"
    action_parameters {
      headers {
        name      = "Access-Control-Allow-Credentials"
        operation = "set"
        value     = "false"
      }
      headers {
        name      = "Access-Control-Allow-Headers"
        operation = "set"
        value     = "*"
      }
      headers {
        name      = "Access-Control-Allow-Methods"
        operation = "set"
        value     = "All"
      }
      headers {
        name      = "Access-Control-Allow-Origin"
        operation = "set"
        value     = "*"
      }
      headers {
        name      = "Access-Control-Expose-Headers"
        operation = "set"
        value     = "*"
      }
    }
    description = "Add CORS Header for ${cloudflare_record.www.hostname}"
    enabled     = true
    expression  = <<-EOF
    (
      http.host eq "${cloudflare_record.www.hostname}" and
      starts_with(http.request.uri.path, "/static/cors/")
    )
    EOF
  }
}
