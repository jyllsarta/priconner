# == Schema Information
#
# Table name: drops
#
#  id       :integer          not null, primary key
#  stage_id :integer          default(0), not null
#  item_id  :integer          default(0), not null
#  priority :integer          default(0), not null
#

class Drop < ApplicationRecord
    belongs_to :stage
    belongs_to :item
end
