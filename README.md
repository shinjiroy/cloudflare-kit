# cloudflare-kit

CloudflareのCDN用Terraform構成案

## 管理方法

Cloudflareはドメイン毎にZoneという物を作ります。  
選択するプラン、契約内容によって、例えば検証環境と本番環境で異なるZoneを作ることが難しい場合があります。  
難しい場合に検証環境と本番環境用ドメインを準備したい場合は、同じZoneに設定を共存させることになります。

ですので、Terraform(Terragrunt)で管理する場合は環境別ではなく**ドメイン別でディレクトリを分ける**ようにすればどちらの場合でも対応できます。

例えば、本番環境`www.hoge.com`と検証環境`test.hoge.com`が欲しい場合、

1. `www.hoge.com`用Zoneと`test.hoge.com`用Zoneを作って良い場合
2. `hoge.com`用Zoneしか作れない場合

がある。  
1の場合は、`/domains`以下に`/www_hoge_com`,`/test_hoge_com`のようなディレクトリを、`/modules`以下に`/www_hoge_com`のようなディレクトリを作成し、  
同じtfファイルを見る。  
2の場合は、`/domains`以下に`/hoge_com`のようなディレクトリを、`/modules`以下に`/hoge_com`のようなディレクトリを作成し、`test.hoge.com`も含めて全て同じファイルに書く形になります。

1,2の方針が途中で変わったら良しなに変更してください。

## 構成

CDNがCloudflare、オリジンがCloudflare以外の想定とし、  
オリジンがアプリケーションサーバー(動的コンテンツを配信)とS3等のストレージサーバー(静的コンテンツを配信)があり、パスによって変わるものとします。
