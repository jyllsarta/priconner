# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require "csv"

EXPORT_TABLES = [:items, :forges, :drops, :stages, :equips, :characters]

EXPORT_TABLES.map(&:to_s).each do |table_name|
  clazz = table_name.singularize.camelize.constantize
  clazz.delete_all
  accepted_attributes = clazz.new.attributes.keys.map(&:to_sym)
  CSV.open("masterdata/seeds/#{table_name}.csv", headers: true, header_converters: :symbol) do |csv|
    csv.each do |line|
      attributes = line.to_h.select{|k, v| k.in? accepted_attributes}
      record = clazz.new(attributes)
      record.save!(validate: false)
    end
  end
  puts "created #{clazz} (#{clazz.count})"
end

puts "done!"