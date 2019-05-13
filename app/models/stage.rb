# == Schema Information
#
# Table name: stages
#
#  id              :integer          not null, primary key
#  area            :integer          default(0), not null
#  location        :integer          default(0), not null
#  is_hard         :integer          default(0), not null
#  require_stamina :integer          default(0), not null
#

class Stage < ApplicationRecord
  has_many :drops
  def name
    self.is_hard? ? "#{area}-#{location}(HARD)" : "#{area}-#{location}"
  end

  def main_drops
    drops.where("priority <= 3")
  end

  def sub_drops
    drops.where("priority > 3")
  end
end
