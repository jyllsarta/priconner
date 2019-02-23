namespace :fetch do
  task :drops => :environment do 
    # n章のドロップ
    url = "https://gamewith.jp/pricone-re/article/show/99456"
    html = open(url) {|f| f.read}
    doc = Nokogiri::HTML.parse(html, nil, nil)

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

  private
  def write(content, filename)
    File.open("tmp/#{filename}", "w") do |f|
      f.write(content)
    end
  end
end


