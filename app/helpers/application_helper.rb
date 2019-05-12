module ApplicationHelper
  def full_title(content_title)
    return "プリコネRアイテム素材効率劇場" if content_title.blank?
    "#{content_title} | プリコネRアイテム素材効率劇場"
  end

  def ogp_image
    "#{root_url}images/ogp.png"
  end
end
