# == Schema Information
#
# Table name: stages
#
#  id       :integer          not null, primary key
#  area     :integer          default(0), not null
#  location :integer          default(0), not null
#  is_hard  :integer          default(0), not null
#

class Stage < ApplicationRecord
  has_many :drops
  def name
    self.is_hard? ? "#{area}-#{location}(H)" : "#{area}-#{location}"
  end

  def main_drops
    drops.where("priority <= 3")
  end

  def sub_drops
    drops.where("priority > 3")
  end

  # 一石二鳥 = これらのアイテムを2つ以上このステージで回収できるか？
  def serving_two_ends?(items)
    (drops.pluck(:item_id) & items.pluck(:id)).count >= 2
  end

  def self.serving_stages(items)
    self.includes(:drops).select{|stage| stage.serving_two_ends?(items)}
  end
end
