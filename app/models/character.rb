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

  def accumulate_equips_by_key(key)
    hash = {}
    self.equips.each do |item|
      hash[item[key]] ||= []
      hash[item[key]].push(item)
    end
    hash
  end
end
