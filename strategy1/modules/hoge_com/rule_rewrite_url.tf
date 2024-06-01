resource "cloudflare_ruleset" "rewrite_url" {
  kind    = "zone"
  name    = "default"
  phase   = "http_request_transform"
  zone_id = cloudflare_zone.zone.id

  # Ruleは後勝ちなので範囲の広い物から順に書く
  rules {
    action = "rewrite"
    action_parameters {
      uri {
        path {
          expression = <<-EOF
          concat("/v2", http.request.uri.path)
          EOF
          # expression = <<-EOF
          # concat("/v3", http.request.uri.path)
          # EOF
        }
      }
    }
    description = "Rewrite to api version for ${cloudflare_record.www.hostname}"
    enabled     = true
    expression  = <<-EOF
    (http.host eq "${cloudflare_record.www.hostname}" and starts_with(http.request.uri.path, "/api/"))
    EOF
  }
}
