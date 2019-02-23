namespace :fetch do
  task :character => :environment do 
    # キャラ詳細の取得
    url = "https://appmedia.jp/priconne-redive/2781829"
    html = open(url) {|f| f.read}
    doc = Nokogiri::HTML.parse(html, nil, nil)

    equips_table = doc.css(:h3).select{|d| d.content == "ランク毎の装備一覧"}.first.next.next

    requirements = []
    equips_table.css(:tr).each do |row|
      rank = []
      row.css(:td).each do |td|
        img = td.css(:img).first
        a = td.css(:a)&.first
        attributes = OpenStruct.new
        attributes.image_id = img.attr(:class)&.split&.select{|x| x.starts_with?("wp")}&.first
        attributes.img_src = img.attr(:src)
        attributes.alt = img.attr(:alt)
        attributes.link_to = a&.attr(:href)
        rank.push(attributes.to_h)
      end
      requirements.push(rank)
    end
    write(requirements, "chika.hash")
  end

  private
  def write(content, filename)
    File.open("tmp/#{filename}", "w") do |f|
      f.write(content)
    end
  end
end


