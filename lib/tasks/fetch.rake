namespace :fetch do
  task :drops => :environment do 
    # n章のドロップ
    url = "https://gamewith.jp/pricone-re/article/show/99456"
    doc = fetch(url)

    table = doc.css(".puri_itiran-table table").first

    result = []
    table.css(:tr).each do |tr|
      stage = OpenStruct.new
      stage.stage_name = tr.css(:th).text
      td = tr.css(:td)
      as = td.css(:a)

      # ドロップのリストを取り込み(priority順であることを期待)
      stage.drops = []
      as.each do |a|
        img = a.css(:img)&.first
        drop = OpenStruct.new
        drop.img_src = img&.attr(:src)
        drop.link_to = a&.attr(:href)
        stage.drops.push(drop.to_h)
      end

      result.push(stage.to_h)
    end
    write(result.to_h.to_json, "drops_10.hash")
  end


  task :items => :environment do
    # Item, Forgeの取得
    url = "https://gamewith.jp/pricone-re/article/show/99065"
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
    materials.css(:td).each do |td|
      material = OpenStruct.new
      material.img_src = td.css(:img).first.attr("data-original") || td.css(:img).first.attr(:src)
      material.text = td.text
      result.materials.push(material.to_h)
    end

    write(result.to_h.to_json, "paradin.hash")
  end

  task :characters => :environment do
    url = "https://gamewith.jp/pricone-re/article/show/92875"
    doc = fetch(url)
    result = OpenStruct.new

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

    write(result.to_h.to_json, "zyta.hash")
  end

  private
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


