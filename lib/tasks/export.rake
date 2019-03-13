namespace :export do
  task :table, [:model_name] => :environment do |_, args|

    File.open("tmp/export_#{args.model_name}.csv", "w") do |f|
      model = args.model_name.constantize
      attributes = model.first.attributes.each_key.to_a.join(",")
      puts attributes
      f.puts(attributes)
      model.all.each do |record|
        values = record.attributes.each_value.to_a.join(",")
        puts values
        f.puts(values)
      end
    end
  end

  task :dump_all => :environment do 
    export_tables = ["Character", "Drop", "Equip", "Forge", "Item", "Stage"]
    export_tables.each do |table|
      Rake::Task["export:table"].execute(Rake::TaskArguments.new([:model_name], [table]))
    end 
  end
end


