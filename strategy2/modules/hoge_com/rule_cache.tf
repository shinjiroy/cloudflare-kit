resource "cloudflare_ruleset" "cache_rules" {
  kind    = "zone"
  name    = "default"
  phase   = "http_request_cache_settings"
  zone_id = cloudflare_zone.zone.id

  # Ruleは後勝ちなので範囲の広い物から順に書く
  # 本番用を最後に書くようにする。(最初でもいいけれど)
  # 検証用
  rules {
    # デフォルト
    action = "set_cache_settings"
    action_parameters {
      cache = true
      cache_key {
        custom_key {
          cookie {
            include = ["ab"]
          }
          header {
            include        = ["X-Hoge-Header"]
            exclude_origin = false # オリジンにも転送する
          }
          host {
            resolved = false
          }
          query_string {
            exclude = ["utm_content"]
          }
          user {
            geo = true
          }
        }
      }
      edge_ttl {
        mode = "bypass_by_default" # Cache-Controlを見てキャッシュするか決める。無ければキャッシュしない。
      }
      browser_ttl {
        mode = "respect_origin" # こちらもオリジンで決めてもらう
      }
    }
    description = "Default Rule for Contents on ${cloudflare_record.test.hostname}"
    enabled     = true
    expression  = <<-EOF
    (http.host eq "${cloudflare_record.test.hostname}")
    EOF
  }
  rules {
    # 静的ファイル用
    action = "set_cache_settings"
    action_parameters {
      cache = true
      cache_key {
        custom_key {
          header {
            exclude_origin = true # ヘッダをオリジンに転送しない。
          }
          query_string {
            include = ["*"] # クエリパラメータ全部含める
          }
        }
      }
      # 静的ファイルはCacheControlを付けない想定とする
      edge_ttl {
        default = 86400
        mode    = "override_origin"
      }
      browser_ttl {
        mode    = "override_origin"
        default = 3600 # ブラウザ側は短めに
      }
    }
    description = "Cache Rule for Static Contents on ${cloudflare_record.test.hostname}"
    enabled     = true
    expression  = <<-EOF
    (http.host eq "${cloudflare_record.test.hostname}" and starts_with(http.request.uri.path, "/static/"))
    EOF
  }
  # 本番用
  rules {
    # まずはデフォルトから
    action = "set_cache_settings"
    action_parameters {
      cache = true
      cache_key {
        custom_key {
          cookie {
            include = ["ab"]
          }
          header {
            include        = ["X-Hoge-Header"]
            exclude_origin = false # オリジンにも転送する
          }
          host {
            resolved = false
          }
          query_string {
            exclude = ["utm_content"]
          }
          user {
            geo = true # 国別でキャッシュしてみたり
          }
        }
      }
      edge_ttl {
        mode = "bypass_by_default" # Cache-Controlを見てキャッシュするか決める。無ければキャッシュしない。
      }
      browser_ttl {
        mode = "respect_origin" # こちらもオリジンで決めてもらう
      }
    }
    description = "Default Rule for Contents on ${cloudflare_record.www.hostname}"
    enabled     = true
    expression  = <<-EOF
    (http.host eq "${cloudflare_record.www.hostname}")
    EOF
  }
  rules {
    # 静的ファイル用
    action = "set_cache_settings"
    action_parameters {
      cache = true
      cache_key {
        custom_key {
          header {
            exclude_origin = true # ヘッダをオリジンに転送しない。
          }
          query_string {
            include = ["*"] # クエリパラメータ全部含める
          }
        }
      }
      # 静的ファイルはCacheControlを付けない想定とする
      edge_ttl {
        default = 86400
        mode    = "override_origin"
      }
      browser_ttl {
        mode    = "override_origin"
        default = 3600 # ブラウザ側は短めに
      }
    }
    description = "Cache Rule for Static Contents on ${cloudflare_record.www.hostname}"
    enabled     = true
    expression  = <<-EOF
    (http.host eq "${cloudflare_record.www.hostname}" and starts_with(http.request.uri.path, "/static/"))
    EOF
  }
}
