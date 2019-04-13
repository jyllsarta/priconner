# == Schema Information
#
# Table name: forges
#
#  id               :integer          not null, primary key
#  forge_item_id    :integer          default(0), not null
#  material_item_id :integer          default(0), not null
#  count            :integer          default(0), not null
#

class Forge < ApplicationRecord
  belongs_to :forge_item, class_name: "Item"
  belongs_to :material_item , class_name: "Item"

  def accumulate
    return self if material_item.forges.empty?
    material_item.forges.map(&:accumulate)
  end
end
