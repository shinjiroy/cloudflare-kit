# cloudflare-kit方針2

方針2の構成です。Terragrunt使う必要すらないですが、方針変わった後を考慮し、Terragruntを使うようにしています。

## ポイント

各PhaseのRuleを1Zoneにつき1つしか作れないのでRuleだけ環境別に分けるということも出来ない。  
そしてRuleがCloudflareのCDNの肝となる設定といっても過言ではないため、DNSレコード等を環境別に分けることも出来るが、それらも含めて一括で管理します。

## デプロイ方法

検証用、本番用も纏めてデプロイせざるを得ません。

1. `cp .env.example .env`
2. `.env`の内容を書く
3. `./deploy.sh`を実行
