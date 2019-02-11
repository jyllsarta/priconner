# README

プリコネ攻略するやつ

## run

```shell
bundle install
rails db:create
bundle exec ridgepole -c config/database.yml -E development --apply -f db/Schemafile
rails s
```

## Schema update

いつか簡単なrakeタスクに落としたい

* `bundle exec ridgepole -c config/database.yml -E development --apply -f db/Schemafile`