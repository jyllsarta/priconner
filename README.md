# README

プリコネ攻略するやつ

* アイテム素材を柔軟に検索可能

## Run

### preference

```shell
bundle install
rails db:create
bundle exec ridgepole -c config/database.yml -E development --apply -f db/Schemafile
```

### seed

このへんちょっとまだ

```shell
git clone https://github.com/jyllsarta/priconeer-masterdata.git masterdata
rails db:seed
```

### put binary

```shell
rm -r public
git clone https://github.com/jyllsarta/priconeer-binary.git public
```

### start server

```shell
rails s
```

## scrape

* `rails 'fetch:item_indexes'`
* `rails 'fetch:character_indexes'`
* `rails 'fetch:drop_indexes'`

* `rails 'import:item_indexes'`
  * 警告はすべて Y で続行
  * Item, Forgeテーブルが埋まる
* `rails 'import:character_indexes'`
  * 警告はすべて Y で続行
  * Equip, Characterテーブルが埋まる
* `rails 'import:drop_indexes'`
  * 警告はすべて Y で続行
  * Stage, Dropテーブルが埋まる

キャラは要求素材(=Equip)を埋めるため、Itemに依存している。先にItemのimportを行うこと
同様にDropはItem.idに依存するため、先にItemのimportが必要

## Schema update

* `bundle exec ridgepole -c config/database.yml -E development --apply -f db/Schemafile`

* `bundle exec annotate`

## エンドポイントを生やしたら

* `bundle exec annotate -r`
