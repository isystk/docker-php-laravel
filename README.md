🌙 docker-php-laravel
====

![GitHub issues](https://img.shields.io/github/issues/isystk/docker-php-laravel)
![GitHub forks](https://img.shields.io/github/forks/isystk/docker-php-laravel)
![GitHub stars](https://img.shields.io/github/stars/isystk/docker-php-laravel)
![GitHub license](https://img.shields.io/github/license/isystk/docker-php-laravel)


## 📗 プロジェクトの概要

Dockerを利用したLaravelの環境構築を行います。

## 📦 ディレクトリ構造

```
.
├── docker （各種Daemon）
│   │
│   ├── apache （Webサーバー）
│   │   ├── conf.d (apacheの設定ファイル)
│   │   └── logs （apacheのログ）
│   ├── mysql （DBサーバー）
│   │   └── logs （mysqlのログ）
│   ├── php （PHP-FRM）
│   │   └── logs （phpのログ）
│   └── phpmyadmin （DB管理ツール）
│
├── htdocs （Apache公開ディレクトリ）
│   │
│   ├── app
│   │   ├── Console (バッチアプリケーション)
│   │   ├── Exceptions (例外処理)
│   │   ├── Http （Webアプリケーション）
│   │   ├── Models（モデル）
│   │   ├── Prociders（サービスプロバイダー）
│   │   └── Services（共通処理）
│   ├── bootstrap
│   ├── config
│   ├── database
│   ├── public
│   ├── resources
│   ├── routes
│   ├── storage
│   ├── tests
│   └── composer.json
└── dc.sh （Dockerの起動用スクリプト）
```

## 🖊️ Docker 操作用シェルスクリプトの使い方

```
Usage:
  dc.sh [command] [<options>]

Options:
  stats|st                 Dockerコンテナの状態を表示します。
  init                     Dockerコンテナ・イメージ・生成ファイルの状態を初期化します。
  start                    すべてのDaemonを起動します。
  stop                     すべてのDaemonを停止します。
  apache restart           Apacheを再起動します。
  mysql login              MySQLデータベースにログインします。
  mysql export <PAHT>      MySQLデータベースのdumpファイルをエクスポートします。
  mysql import <PAHT>      MySQLデータベースにdumpファイルをインポートします。
  mysql restart            MySQLデータベースを再起動します。
  php login                PHP-FPMのサーバーにログインします。
  php cache                Laravelのキャッシュをクリアします。
  php migrate              Laravelのマイグレードを実行します。
  php seed                 Laravelのテストデータを登録します。
  --version, -v     バージョンを表示します。
  --help, -h        ヘルプを表示します。
```

## 🔧 環境構築手順

### 前提条件

Docker 及び Docker-compose が利用できる事が前提となります。
Windowsの場合は、WSLなどを利用してシェルが利用できる環境を整える必要があります。

### Dockerで各種デーモンを起動する

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

### Laravelの初期設定

```
# PHPサーバーにログインしてみる（composer や artisan などのコマンドは基本的にここで行う）
$ ./dc.sh php login

# モジュールをダウンロード
> composer update

# .envをコピーする
cp .env.example .env

# encryption keyを生成する
php artisan key:generate

# テーブルとテストデータの作成
> php artisan migrate:fresh --seed

# Laravelが書き込むディレクトリの権限を変更
> chmod 777 -R bootstrap/cache
> chmod 777 -R storage

# ブラウザでアクセス
https://localhost/

# サーバーを停止する場合
$ ./dc.sh stop
```

### フロントエンドの開発方法

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

## 🎨 参考

| プロジェクト| 概要|
| :---------------------------------------| :-------------------------------|
| [Laravel8公式ドキュメント](https://readouble.com/laravel/8.x/ja/)| Laravel8公式ドキュメントです。|
| [Bootstrap4 日本語リファレンス](https://getbootstrap.jp/docs/4.4/getting-started/introduction/)| Bootstrap4 日本語リファレンス|


## 🎫 Licence

[MIT](https://github.com/isystk/docker-php-laravel/blob/master/LICENSE)

## 👀 Author

[isystk](https://github.com/isystk)


