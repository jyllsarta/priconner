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

## Schema update

* `bundle exec ridgepole -c config/database.yml -E development --apply -f db/Schemafile`

* `bundle exec annotate`