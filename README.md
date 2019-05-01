# README

プリコネ攻略するやつ

* 指定のスプレッドシートに書いたマスタデータを元にDBを構築
* マスタデータからページを生成しているので柔軟な機能拡張・データ追加が可能

## データは外出し

* マスタ
  * https://github.com/jyllsarta/priconeer-masterdata
  
* 静的ファイル
  * https://github.com/jyllsarta/priconeer-binary

## Run

### preference

```shell
bundle install
rails db:create
bundle exec ridgepole -c config/database.yml -E development --apply -f db/Schemafile
```

### seed

```shell
git clone https://github.com/jyllsarta/priconeer-masterdata.git masterdata
rails db:seed
```

### put binary

```shell
rm -r public/images
cd images
git clone https://github.com/jyllsarta/priconeer-binary.git images
```

### start server

* local

```shell
rails s
```

* if production

```shell
export SECRET_KEY_BASE=なんとかかんとか
sudo SECRET_KEY_BASE=$SECRET_KEY_BASE PORT=80 RAILS_ENV=production bin/rails s
```

## Schema update

* `bundle exec ridgepole -c config/database.yml -E development --apply -f db/Schemafile`

* `bundle exec annotate`

## エンドポイントを生やしたら

* `bundle exec annotate -r`

## デプロイ手順

### セッションに入り、サーバ停止

```shell
sudo su - jyll
tmux a -t "production-home"
^C
```

### マスタ更新・seed

```shell
cd ~/priconner/masterdata
git pull
cd ~/priconner
bundle exec ridgepole -c config/database.yml -E production --apply -f db/Schemafile
RAILS_ENV=production bin/rails db:seed
```

### アセットの更新

```shell
bundle exec rake assets:precompile
```

### run server

```shell
source ~/.bash_profile
sudo SECRET_KEY_BASE=$SECRET_KEY_BASE PORT=80 RAILS_ENV=production bin/rails s
```
