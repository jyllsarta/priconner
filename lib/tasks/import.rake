namespace :import do
  # テーブル毎に必要なハッシュを与えて読み込む

  # アイテムの基本情報を埋める
  task :items, [:page_id] => :environment do |_, args|
    path = "tmp/#{args.page_id}.hash"
    hash = File.open(path, "r") do |f|
      content = f.read
      JSON.parse(content, {symbolize_names: true})
    end

    item = Item.find_by(name: hash[:item_name])
    hash[:params].each do |kv|
      item[to_column_name(kv[:key])] = kv[:value]
    end
    item.save!
  end

  # アイテム一覧から名前とIDのペアだけ作る
  # (ID系ルールは一旦無視してしまうので、何らか対策は必要)
  task :item_indexes => :environment do
    puts "this task will DELETE ALL Item. are you sure? Y/n"
    raise "ok bye~~" unless STDIN.gets.chomp == "Y"
    
    path = "tmp/items.hash"
    hash = File.open(path, "r") do |f|
      content = f.read
      JSON.parse(content, {symbolize_names: true})
    end
    Item.delete_all

    hash[:items].each do |item|
      Item.create!(
        name: item[:name],
        gw_page_id: item[:link_to].split("/").last,
        gw_image_id: item[:img_src].split("/").last.sub("_s.png",""),
      )
    end

    puts "全アイテムの上昇パラメータ・素材情報を取得します。時間がかかります。 続行？ (Y/n)"
    raise "ok bye~~" unless STDIN.gets.chomp == "Y"

    Item.all.each do |item|
      pp item
      Rake::Task["fetch:items"].invoke(item.gw_page_id)
      Rake::Task["fetch:items"].reenable
      Rake::Task["import:items"].invoke(item.gw_page_id)
      Rake::Task["import:items"].reenable
      sleep(1)
      #TODO 素材をimport
    end
  end

  private

  def to_column_name(key)
    mapping = {
      "HP": :hp,
      "物理攻撃力": :atk,
      "物理防御力": :def,
      "魔法攻撃力": :matk,
      "魔法防御力": :mdef,
      "TP上昇": :tpgain,
      "回復量上昇": :healgain,
      "TP消費軽減": :tpreduce,
      "HP自動回復": :autohp,
      "TP自動回復": :autotp,
      "物理クリティカル": :cri,
      "魔法クリティカル": :mcri,
      "命中": :hit,
      "回避": :eva,
      "HP吸収": :drain,
    }
    mapping[key.to_sym]
  end
end


