namespace :fetch do

  # 8-17章のみだけど、ドロップまとめからドロップ情報を一気に取り込み
  task :drop_indexes => :environment do 
    url = "https://gamewith.jp/pricone-re/article/show/130587"
    doc = fetch(url)

    table = doc.css(".puri_sibori table").first

    result = OpenStruct.new
    result.drops = []

    table.css(:tr)[1..-1].each do |tr|
      drop = OpenStruct.new
      stage_name = tr.css(:td)[0].text
      is_hard = stage_name.starts_with?("H")
      # ‐ ←こいつはマイナスではなくハイフン(E2 80 90)なので超注意してくれ
      area, location = stage_name.sub("H","").split("‐")
      # なんかマイナスの場合もある... その場合には - でスプリットをかける
      area, location = stage_name.sub("H","").split("-") if location.nil?

      priority = 1
      #メインドロップ
      main_drops = tr.css(:td)[1]
      main_drops.css(:a).each do |a|
        link_to = a.attr(:href)
        drop.link_to = link_to
        drop.stage_name = stage_name
        drop.is_hard = is_hard
        drop.area = area
        drop.location = location
        drop.priority = priority
        result.drops.push(drop.to_h)
        priority += 1
      end

      #サブドロップ
      main_drops = tr.css(:td)[2]
      main_drops.css(:a).each do |a|
        link_to = a.attr(:href)
        drop.link_to = link_to
        drop.stage_name = stage_name
        drop.is_hard = is_hard
        drop.area = area
        drop.location = location
        drop.priority = priority
        result.drops.push(drop.to_h)
        priority += 1
      end
    end
    write(result.to_h.to_json, "drops.hash")
  end

  task :items, [:page_id] => :environment do |_, args|
    # Item, Forgeの取得
    url = "https://gamewith.jp/pricone-re/article/show/#{args[:page_id]}"
    doc = fetch(url)

    result = OpenStruct.new
    result.params = []

    # アイテム名
    result.item_name = doc.css(:h1).text.match(/「(.*)」/).captures.first

    # 上昇パラメータ一覧
    status = doc.css(".puri_soubi_table table").first
    status.css(:tr)[1..-1].each do |tr|
      params = OpenStruct.new
      params.key = tr.css(:th).text
      params.value = tr.css(:td).text
      result.params.push(params.to_h)
    end

    # 素材
    result.materials = []
    materials = doc.css(".puri-sozai_table table").first
    # アイテム直ドロップ系最序盤素材の場合はmaterialsが存在しないことがある
    if materials.present?
      materials.css(:td).each do |td|
        material = OpenStruct.new
        material.img_src = td.css(:img).first.attr("data-original") || td.css(:img).first.attr(:src)
        material.text = td.text
        result.materials.push(material.to_h)
      end
    end

    write(result.to_h.to_json, "#{args[:page_id]}.hash")
  end

  task :characters, [:page_id] => :environment do |_, args|
    url = "https://gamewith.jp/pricone-re/article/show/#{args[:page_id]}"
    doc = fetch(url)
    result = OpenStruct.new

    #キャラ名(苦しい...)
    result.name = doc.css(:h1).text.match(/】(.*)の評価/).captures.first

    # 要求装備
    # こいつはかなり苦しい... もうちょい安全なセレクタを書きたいけど全然ない...
    rank_headers = doc.css(:th).select{|th| th.text.starts_with?("Rank")}
    result.equips = []
    rank_headers.each do |rank_header|
      rankup_materials = []
      tr = rank_header.parent.next
      tr.css(:td).each do |td|
        material = OpenStruct.new
        material.link_to = td.css(:a)&.first&.attr(:href)
        material.img_src = td.css(:img).first.attr("data-original") || td.css(:img).first.attr(:src)
        rankup_materials.push(material.to_h)
      end
      result.equips.push(rankup_materials)
    end

    # 初期レアリティ、位置
    # これもセレクタきつい...
    initial_rarity_index = doc.css(".puri_kihon_table th").select{|th| th.text.starts_with?("初期レア度")}
    initial_rarity = initial_rarity_index.first.parent.css(:td).text
    result.initial_rarity = initial_rarity

    position_type_index = doc.css(".puri_kihon_table th").select{|th| th.text.starts_with?("タイプ")}
    position, type = position_type_index.first.parent.css(:td).text.split("/").map(&:strip)
    result.position = position
    result.type = type

    # キャラ詳細ページID(名前で引くとイリヤ→イリヤ・オーンスタインとか水着スズメ→水着スズメ(サマー)とかでひどいことに...)
    result.gw_page_id = args[:page_id]

    write(result.to_h.to_json, "#{args[:page_id]}.hash")
  end


  # キャラ一覧
  task :character_indexes => :environment do
    url = "https://gamewith.jp/pricone-re/article/show/92923"
    doc = fetch(url)
    result = OpenStruct.new

    table = doc.css(".puri_chara table")
    result.characters = []
    table.css(:tr)[1..-1].each do |tr|
      character = OpenStruct.new
      tds = tr.css(:td)
      character.name = tds[0].css(:a).first.text
      character.img_src = tds[0].css(:a).css(:img).first.attr("data-original") || tds[0].css(:a).css(:img).first.attr(:src)
      character.link_to = tds[0].css(:a)&.first&.attr(:href)
      character.initial_rarity = tds[1].text
      character.position = tds[2].text

      result.characters.push(character.to_h)
    end

    write(result.to_h.to_json, "characters.hash")
  end

  task :item_indexes => :environment do
    url = "https://gamewith.jp/pricone-re/article/show/94204"
    doc = fetch(url)
    result = OpenStruct.new

    result.items = []
    doc.css(".puri_equip-table table").each do |table|
      table.css(:tr).each do |tr|
        # インデックス行をすっ飛ばす
        next if tr.css(:th).length > 0
        # 銀枠装備欄にのみ謎の空trがあるので、空っぽかったら飛ばす
        next if tr.css(:a).length == 0
        item = OpenStruct.new
        td = tr.css(:td).first
        item.name = td.css(:a).first.text
        item.link_to = td.css(:a).first.attr(:href)
        item.img_src = td.css(:img).first.attr("data-original") || td.css(:img).first.attr(:src)
        # ~~の欠片 or ~~の設計図 or null(直ドロップ)
        item.primary_material_name = tr.css(:td)[1]&.css(:a)&.first&.text
        image_or_null = tr.css(:td)[1]&.css(:a)&.css(:img)&.first
        item.primary_material_img_src = image_or_null&.attr("data-original") || image_or_null&.attr(:src)
        result.items.push(item.to_h)
      end
    end
    write(result.to_h.to_json, "items.hash")
  end

  # gw_image_idを持つキャラと装備の画像を一括取得
  task :images => :environment do
      Item.all.each do |item|
        puts "#{item.id}/#{Item.count} #{item.name}"
        save_image(Rails.root.join("public", "images", "items", "#{item.gw_image_id}.png"), "https://gamewith.akamaized.net/article_tools/pricone-re/gacha/#{item.gw_image_id}_s.png")
      end
      Character.all.each do |character|
        puts "#{character.id}/#{Character.count} #{character.name}"
        save_image(Rails.root.join("public", "images", "characters", "#{character.gw_image_id}.png"), "https://gamewith.akamaized.net/article_tools/pricone-re/gacha/#{character.gw_image_id}_i.png")
      end
    end
    
    private
    
    def save_image(filepath, url)
      return if File.exists?(filepath)
      File.open(filepath, 'wb') do |file|
        open(url, 'rb') do |fetched|
          file.write(fetched.read)
        end
        sleep(1)
    end
  end

  def write(content, filename)
    File.open("tmp/#{filename}", "w") do |f|
      f.write(content)
    end
  end

  def fetch(url)
    html = open(url) {|f| f.read}
    Nokogiri::HTML.parse(html, nil, nil)
  end
end


