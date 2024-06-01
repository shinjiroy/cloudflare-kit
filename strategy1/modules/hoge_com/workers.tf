# workerのパスへの紐づけは、最も具体的なパターンが優先されます。
# https://developers.cloudflare.com/workers/configuration/routing/routes/#matching-behavior
locals {
  # このパスも環境別にした方が良いかもしれないが増えれば増えるほど管理がつらくなる
  default_worker_path = [
    "*"
  ]
  static_worker_path = [
    "/static/hoge/*",
    "/static/fuga/*",
  ]
  # 全てがdefaultに向いて、Workerのコストが無駄にかからないように「紐づけない」設定が必要
  ignore_worker_path = [
    "/static/*",
  ]
}

resource "cloudflare_worker_script" "default" {
  account_id = var.account_id
  name       = "default-worker"
  content    = file("./worker_function/hoge-default.js")
  module     = true # ESmoduleとして作る
}
resource "cloudflare_worker_script" "static" {
  account_id = var.account_id
  name       = "static-worker"
  content    = file("./worker_function/hoge-static.js")
  module     = true # ESmoduleとして作る
}
resource "cloudflare_worker_route" "default" {
  for_each = toset(local.default_worker_path)

  zone_id     = cloudflare_zone.zone.id
  pattern     = "${cloudflare_record.www.hostname}${each.value}"
  script_name = cloudflare_worker_script.default.name
}
resource "cloudflare_worker_route" "static" {
  for_each = toset(local.static_worker_path)

  zone_id     = cloudflare_zone.zone.id
  pattern     = "${cloudflare_record.www.hostname}${each.value}"
  script_name = cloudflare_worker_script.static.name
}

resource "cloudflare_worker_route" "ignore" {
  for_each = toset(local.ignore_worker_path)

  zone_id     = cloudflare_zone.zone.id
  pattern     = "*${each.value}"
  script_name = null
}
