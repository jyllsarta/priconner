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
end
