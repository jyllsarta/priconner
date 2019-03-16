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
#  gw_image_id :integer          default(0), not null
#  gw_page_id  :integer          default(0), not null
#

## idの定義
## ランク_任意の連番_素材フラグとする
## 00_00_00

class Item < ApplicationRecord
    # 素材に指定されているForgeが引ける
    has_many :forges, foreign_key: :forge_item_id
    # 素材アイテムが直接引ける
    has_many :materials, through: :forges, source: :material_item

    has_many :drops
    has_many :stages, through: :drops, as: :drop_stages

    # SQLが大量に発行される要因なので、キャッシュするか直接DBに埋め込んでしまいたい
    def primary_material
        forges.where("count > 1").first&.material_item
    end

    # これが集められるところ
    # primary_material がドロップするステージか || 自分自身がドロップするステージ
    def producing_stages
        return stages if stages.exists?
        primary_material&.stages || []
    end

    def parameters
        self.slice(:hp, :atk, :def, :matk, :mdef, :tpgain, :healgain, :tpreduce, :autohp, :autotp, :cri, :mcri, :hit, :eva, :drain)
    end

    # 効果値のあるものを抽出
    def affective_parameters
        parameters.select{|_, value| value.positive?}
    end
end
