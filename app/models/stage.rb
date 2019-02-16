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
end
