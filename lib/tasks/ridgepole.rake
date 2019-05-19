namespace :db do
  namespace :ridgepole do
    task :apply => :environment do
      # バッククオートだと標準出力をこっちに流してくれなくなるので、systemでコマンド実行
      system('bundle exec ridgepole -c config/database.yml -E development --apply -f db/Schemafile')
    end
  end
end


