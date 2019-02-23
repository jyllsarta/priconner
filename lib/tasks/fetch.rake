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
    write(result, "drops_10.hash")
  end


  task :items => :environment do
    # Item, Forgeの取得
    url = "https://gamewith.jp/pricone-re/article/show/99065"
    doc = fetch(url)

    result = OpenStruct.new
    result.params = []

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

    write(result.to_h, "paradin.hash")
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


