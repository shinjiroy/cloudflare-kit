resource "cloudflare_ruleset" "configuration_rules" {
  kind    = "zone"
  name    = "default"
  phase   = "http_config_settings"
  zone_id = cloudflare_zone.zone.id

  rules {
    # HTTPSへのRewriteくらいは一緒でも良い
    action = "set_config"
    action_parameters {
      automatic_https_rewrites = true # http を https に
    }
    description = "Rewrite Rule of HTTP to HTTPS"
    enabled     = true
    expression  = "true"
  }
}
