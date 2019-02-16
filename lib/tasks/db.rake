namespace :db do
    task :seed => :environment do 
        # 仮シードの投入
        puts "seeded!"
    end
end