# == Schema Information
#
# Table name: equips
#
#  id           :integer          not null, primary key
#  character_id :integer          default(0), not null
#  item_id      :integer          default(0), not null
#  position     :integer          default(0), not null
#  rank         :integer          default(0), not null
#

class Equip < ApplicationRecord
    belongs_to :character
    belongs_to :item
end
