# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  name        :string           default(""), not null
#  hp          :integer          default(0), not null
#  atk         :integer          default(0), not null
#  def         :integer          default(0), not null
#  matk        :integer          default(0), not null
#  mdef        :integer          default(0), not null
#  tpgain      :integer          default(0), not null
#  healgain    :integer          default(0), not null
#  tpreduce    :integer          default(0), not null
#  autohp      :integer          default(0), not null
#  autotp      :integer          default(0), not null
#  cri         :integer          default(0), not null
#  mcri        :integer          default(0), not null
#  hit         :integer          default(0), not null
#  eva         :integer          default(0), not null
#  drain       :integer          default(0), not null
#  category    :integer          default(0), not null
#  is_material :boolean          default(FALSE), not null
#

## idの定義
## ランク_任意の連番_素材フラグとする
## 00_00_00

class Item < ApplicationRecord
end
