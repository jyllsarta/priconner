module ApplicationHelper
  def full_title(content_title)
    return "プリコネRアイテム素材効率劇場" if content_title.blank?
    "#{content_title} | プリコネRアイテム素材効率劇場"
  end

  def ogp_image
    "#{root_url}images/ogp.png"
  end

  def random_top_image_url
    # . と .. を除く簡単な方法ってあんのかな
    filename = Rails.root.join("public/images/top_illust").entries.reject{|e| e.to_s.starts_with?(".")}.map(&:to_s).sample
    "#{root_url}images/top_illust/#{filename}"
  end
end
