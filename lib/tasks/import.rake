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

    # 素材も行く
    hash[:materials].each do |matreial|
      gw_image_id =  matreial[:img_src].split("/").last.sub("_s.png","")
      material_item_id = Item.find_by(gw_image_id: gw_image_id).id
      count = matreial[:text].split("×")[1] #なんか...これも表記揺れありそうだな... なかったわ
      Forge.find_or_create_by(
        forge_item_id: item.id,
        material_item_id: material_item_id,
        count: count
      )
    end
  end

  # アイテム一覧から名前とIDのペアだけ作る
  # (ID系ルールは一旦無視してしまうので、何らか対策は必要)
  task :item_indexes => :environment do
    puts "this task will DELETE ALL Item and Forge. are you sure? Y/n"
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
      # 素材系アイテムだった場合、(欠片)か(設計図)を追加で生成する
      if item[:primary_material_name].present?
        Item.create!(
          name: item[:primary_material_name],
          gw_page_id: item[:link_to].split("/").last,
          gw_image_id: item[:primary_material_img_src].split("/").last.sub("_s.png",""),
          is_material: true
        )
      end
    end

    puts "全アイテムの上昇パラメータ・素材情報を取得します。時間がかかります。 続行？ (Y/n)"
    raise "ok bye~~" unless STDIN.gets.chomp == "Y"
    Forge.delete_all

    Item.all.each do |item|
      pp item
      next if item.is_material
      Rake::Task["fetch:items"].invoke(item.gw_page_id)
      Rake::Task["fetch:items"].reenable
      Rake::Task["import:items"].invoke(item.gw_page_id)
      Rake::Task["import:items"].reenable
      sleep(1)
    end
  end

  
  # キャラ詳細、というか装備するアイテム一覧の取り込み
  # (ID系ルールは一旦無視してしまうので、何らか対策は必要)
  task :characters, [:page_id] => :environment do |_, args|
    path = "tmp/#{args.page_id}.hash"
    hash = File.open(path, "r") do |f|
      content = f.read
      JSON.parse(content, {symbolize_names: true})
    end

    # 詳細ページのURLで一致を取る
    character_id = Character.find_by(gw_page_id: hash[:gw_page_id]).id

    hash[:equips].each_with_index do |rank, rank_i|
      rank.each_with_index do |item, item_i|

        # 未実装アイコンにはリンクが張っていないのでスキップするべき
        next unless item[:link_to].present? 

        gw_page_id = item[:link_to].split("/").last
        # 冪等性確保のためfind or createにする
        Equip.find_or_create_by(
          character_id: character_id,
          item_id: item_id(gw_page_id),
          rank: rank_i + 1,
          position: item_i + 1
        )
      end
    end
  end


  # キャラ一覧ページの取り込み
  # (ID系ルールは一旦無視してしまうので、何らか対策は必要)
  task :character_indexes => :environment do
    puts "this task will DELETE ALL Character. are you sure? Y/n"
    raise "ok bye~~" unless STDIN.gets.chomp == "Y"
    
    path = "tmp/characters.hash"
    hash = File.open(path, "r") do |f|
      content = f.read
      JSON.parse(content, {symbolize_names: true})
    end
    Character.delete_all

    hash[:characters].each do |character|
      Character.create!(
        name: character[:name],
        initial_rarity: character[:initial_rarity][-1].to_i, # "☆3" to 3
        position: to_position(character[:position]),
        gw_page_id: character[:link_to].split("/").last,
        gw_image_id: character[:img_src].split("/").last.sub("_s.png",""),
      )
    end

    puts "全キャラの要求素材情報を取得します。時間がかかります。 続行？ (Y/n)"
    raise "ok bye~~" unless STDIN.gets.chomp == "Y"

    Character.all.each do |character|
      pp character
      Rake::Task["fetch:characters"].invoke(character.gw_page_id)
      Rake::Task["fetch:characters"].reenable
      Rake::Task["import:characters"].invoke(character.gw_page_id)
      Rake::Task["import:characters"].reenable
      sleep(1)
    end
  end

  # ドロップとステージ一覧の保存
  # (ID系ルールは一旦無視してしまうので、何らか対策は必要)
  task :drop_indexes => :environment do
    puts "this task will DELETE ALL Stage and Drop. are you sure? Y/n"
    raise "ok bye~~" unless STDIN.gets.chomp == "Y"
    
    path = "tmp/drops.hash"
    hash = File.open(path, "r") do |f|
      content = f.read
      JSON.parse(content, {symbolize_names: true})
    end
    
    Stage.delete_all
    # まずステージを作る
    hash[:drops].each do |drop|
      Stage.find_or_create_by(
        area: drop[:area],
        location: drop[:location],
        is_hard: drop[:is_hard]
        )
    end
    
    Drop.delete_all
    # もう一度回してドロップ情報を埋める
    hash[:drops].each do |drop|
      stage_id = Stage.find_by(
        area: drop[:area],
        location: drop[:location],
        is_hard: drop[:is_hard]
      ).id

      gw_page_id = drop[:link_to].split("/").last
      Drop.find_or_create_by(
        stage_id: stage_id,
        item_id: item_id(gw_page_id),
        priority: drop[:priority]
      )
    end
  end

  # 画像のIDマイグレーション
  task :migrate_filename => :environment do
    Item.all.each do |item|
      path = "#{Rails.root}/public/images/items/%d.png"
      File.rename(path % item.gw_image_id, path % item.id) if File.exist?(path % item.gw_image_id)
      puts "done with #{item.id}"
    end
  end

  # 画像のIDマイグレーション
  task :migrate_character_filename => :environment do
    Character.all.each do |character|
      tmp_path = "#{Rails.root}/public/images/characters/_%d.png"
      path = "#{Rails.root}/public/images/characters/%d.png"
      File.rename(path % character.gw_image_id, tmp_path % character.id) if File.exist?(path % character.gw_image_id)
      puts "done with #{character.id}"
    end
    Character.all.each do |character|
      tmp_path = "#{Rails.root}/public/images/characters/_%d.png"
      path = "#{Rails.root}/public/images/characters/%d.png"
      File.rename(tmp_path % character.id, path % character.id) if File.exist?(tmp_path % character.id)
      puts "done with #{character.id}"
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

  def to_position(key)
    mapping = {
      "前衛": 1,
      "中衛": 2,
      "後衛": 3,
    }
    mapping[key.to_sym]
  end

  def item_id(gw_page_id)
    # 無かったら例外吐いてもらおう
    Item.find_by(gw_page_id: gw_page_id).id
  end
end


