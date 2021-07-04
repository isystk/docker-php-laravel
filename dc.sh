#! /bin/bash

DOCKER_COMPOSE="docker-compose -f docker/docker-compose.yml"

function usage {
    cat <<EOF
$(basename ${0}) is a tool for ...

Usage:
  $(basename ${0}) [command] [<options>]

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
EOF
}

function version {
    echo "$(basename ${0}) version 0.0.1 "
}

case ${1} in
    stats|st)
        docker container stats
    ;;

    init)
        # 停止＆削除（コンテナ・イメージ・ボリューム）
        $DOCKER_COMPOSE down --rmi all --volumes
        rm -Rf ./docker/mysql/logs && mkdir ./docker/mysql/logs && chmod 777 ./docker/mysql/logs
        rm -Rf ./docker/apache/logs && mkdir ./docker/apache/logs && chmod 777 ./docker/apache/logs
        rm -Rf ./docker/php/logs && mkdir ./docker/php/logs && chmod 777 ./docker/php/logs
        chmod 777 ./htdocs
    ;;

    start)
        $DOCKER_COMPOSE up -d
    ;;
    
    stop)
        $DOCKER_COMPOSE down
    ;;

    apache)
      case ${2} in
          login)
              $DOCKER_COMPOSE exec apache /bin/sh
          ;;
          restart)
              $DOCKER_COMPOSE restart apache
          ;;
          *)
              usage
          ;;
      esac
    ;;

    mysql)
      case ${2} in
          login)
              mysql -u root -ppassword -h 127.0.0.1 laravel
          ;;
          export)
              mysqldump --skip-column-statistics -u root -h 127.0.0.1 -A > ${3}
          ;;
          import)
              mysql -u root -h 127.0.0.1 --default-character-set=utf8mb4 < ${3}
              $DOCKER_COMPOSE restart mysql
          ;;
          restart)
              $DOCKER_COMPOSE restart mysql
          ;;
          *)
              usage
          ;;
      esac
    ;;
    
    php)
      case ${2} in
          login)
              $DOCKER_COMPOSE exec php /bin/bash
          ;;
          serve)
              $DOCKER_COMPOSE exec php /bin/bash -c "php artisan serve --host 0.0.0.0"
          ;;
          cache)
              $DOCKER_COMPOSE exec php /bin/bash -c "php artisan config:cache && php artisan route:clear && rm bootstrap/cache/config.php && php artisan cache:clear"
          ;;
          migrate)
              $DOCKER_COMPOSE exec php /bin/bash -c "php artisan migrate:fresh && php artisan migrate:refresh"
          ;;
          seed)
              $DOCKER_COMPOSE exec php /bin/bash -c "php artisan migrate:fresh"
              $DOCKER_COMPOSE exec php /bin/bash -c "composer dump-autoload && php artisan db:seed"
          ;;
          test)
              $DOCKER_COMPOSE exec php /bin/bash -c "./vendor/bin/phpunit --testdox"
          ;;
          *)
              usage
          ;;
      esac
    ;;
    
    help|--help|-h)
        usage
    ;;

    version|--version|-v)
        version
    ;;
    
    *)
        echo "[ERROR] Invalid subcommand '${1}'"
        usage
        exit 1
    ;;
esac


