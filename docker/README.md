# 環境構築手順

## 前提条件

Docker 及び Docker-compose が利用できる事が前提となります。
Windowsの場合は、WSLなどを利用してシェルが利用できる環境を整える必要があります。

## Dockerで各種デーモンを起動する

```
# Dockerコンテナの初期化 (初回のみ)
$ ./dc.sh init

# Dockerコンテナを起動する
$ ./dc.sh start

# MySQLにログインをしてデータベースを確認する（初回のみ立ち上がりに5分程度かかります）
$ ./dc.sh mysql login
> show databases;
laravel が存在していればOK

# Mysqlの操作はPhpMyAdminからブラウザでも可能です。
http://localhost:8888/

```

## Laravelの初期設定

```
# PHPサーバーにログインしてみる（composer や artisan などのコマンドは基本的にここで行う）
$ ./dc.sh php login

# モジュールをダウンロード
> composer update

# テーブルとテストデータの作成
> php artisan migrate:fresh --seed

# Laravelが書き込むディレクトリの権限を変更
> chmod 777 -R bootstrap/cache
> chmod 777 -R storage

# .envをコピーする
cp .env.example .env

# encryption keyを生成する
php artisan key:generate

# ブラウザでアクセス
https://localhost/

# サーバーを停止する場合
$ ./dc.sh stop
```

# フロントエンドの開発方法

```
# nodebrew のインストール
# Windowsの場合
$ curl -L git.io/nodebrew | perl - setup
# Macの場合
$ brew install nodebrew

# Node.js をインストール 
$ mkdir -p ~/.nodebrew/src
$ nodebrew ls-remote
$ nodebrew install v12.21.0
$ nodebrew use v12.21.0
$ npm install -g yarn

# 必要なモジュールをインストール（初回のみ）
$ yarn

# ビルドを実行（resources配下のソースコードがpublic配下にバンドルされます）
$ yarn run dev
```

