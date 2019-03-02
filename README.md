# README

プリコネ攻略するやつ

## Run local

```shell
bundle install
rails db:create
bundle exec ridgepole -c config/database.yml -E development --apply -f db/Schemafile
rails db:seed
rails s
```

## scrape and seed

* `rails 'fetch:item_indexes'`
* `rails 'fetch:character_indexes'`

* `rails 'import:item_indexes'`
  * 警告はすべて Y で続行
  * Itemテーブルが埋まる
* `rails 'import:character_indexes'`
  * 警告はすべて Y で続行
  * Equip, Characterテーブルが埋まる

キャラは要求素材(=Equip)を埋めるため、Itemに依存している。先にItemのimportを行うこと

## Schema update

* `bundle exec ridgepole -c config/database.yml -E development --apply -f db/Schemafile`

* `bundle exec annotate`

## エンドポイントを生やしたら

* `bundle exec annotate -r`
