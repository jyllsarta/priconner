# == Schema Information
#
# Table name: characters
#
#  id             :integer          not null, primary key
#  name           :string           default("0"), not null
#  initial_rarity :integer          default(0), not null
#  position       :integer          default(0), not null
#  gw_page_id     :integer          default(0), not null
#  gw_image_id    :integer          default(0), not null
#

class Character < ApplicationRecord
  has_many :equips
  enum place: { front: 1, middle: 2, back: 3 }

  def accumulate_equips_by_key(key)
    hash = {}
    self.equips.each do |item|
      hash[item[key]] ||= []
      hash[item[key]].push(item)
    end
    hash
  end

  def total_equips
    hash = {}
    # 愚直に定義どおり書くとこうなんだけど、こうやって関連を引いてしまうとN+1か過剰なpreload不可避なので
    # グローバルにForgeからwhereで引いて足してくほうがいいんだと思う
    self.equips.each do |equip|
      item = equip.item
      item&.accumulate_all_materials&.each do |forge|
        hash[forge.material_item] ||= 0
        hash[forge.material_item] += forge.count
      end
    end
    hash
  end

  def image_path
    "/images/characters/#{self.id}.png"
  end
end
