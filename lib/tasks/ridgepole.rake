namespace :db do
  namespace :ridgepole do
    task :apply => :environment do
      puts "apply ridgepole migration to  #{Rails.env}"
      # バッククオートだと標準出力をこっちに流してくれなくなるので、systemでコマンド実行
      system("bundle exec ridgepole -c config/database.yml -E #{Rails.env} --apply -f db/Schemafile")
    end
  end
end


