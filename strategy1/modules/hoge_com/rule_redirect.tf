resource "cloudflare_ruleset" "redirect_rules" {
  kind    = "zone"
  name    = "default"
  phase   = "http_request_dynamic_redirect"
  zone_id = cloudflare_zone.zone.id

  # Ruleは後勝ちなので範囲の広い物から順に書く
  rules {
    action = "redirect"
    action_parameters {
      from_value {
        preserve_query_string = false
        status_code           = 302
        target_url {
          value = "https://example.com/"
        }
      }
    }
    description = "Redirect for Overseas Users on ${cloudflare_record.www.hostname}"
    enabled     = true
    expression  = <<-EOL
    (
      http.host eq "${cloudflare_record.www.hostname}" and
      ip.geoip.country ne "JP" and
      and starts_with(http.request.uri.path, "/restrict/")
    )
    EOL
  }
}
