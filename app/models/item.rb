# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  name        :string           default(""), not null
#  category    :integer          default(0), not null
#  is_material :boolean          default(FALSE), not null
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
#  gw_image_id :integer          default(0), not null
#  gw_page_id  :integer          default(0), not null
#  rank        :integer          default(0), not null
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

  has_many :equips

  enum category_text: {
    "剣": 1,
    "刀": 2,
    "短剣": 3,
    "拳": 4,
    "弓": 5,
    "槍": 6,
    "斧": 7,
    "杖": 8,
    "鎧": 9,
    "盾": 10,
    "靴": 11,
    "頭": 12,
    "アクセサリ": 13
  }

  enum parameter: {
      hp: "HP",
      atk: "物理攻撃力",
      def: "物理防御力",
      matk: "魔法攻撃力",
      mdef: "魔法防御力",
      tpgain: "TP上昇",
      healgain: "回復量上昇",
      tpreduce: "TP消費軽減",
      autohp: "HP自動回復",
      autotp: "TP自動回復",
      cri: "物理クリティカル",
      mcri: "魔法クリティカル",
      hit: "命中",
      eva: "回避",
      drain: "HP吸収",
  }

  # SQLが大量に発行される要因なので、キャッシュするか直接DBに埋め込んでしまいたい
  def primary_material
    forges.where("count > 1").first&.material_item
  end

  # 素材アイテム -> 主要アイテム
  def to_forged
    return nil unless self.is_material
    Forge.where(material_item: self).first.forge_item
  end

  # トータルで結局何が必要なのよ
  def accumulate_all_materials
    self.forges.map(&:accumulate).flatten
  end

  # これを必要とするアイテム一覧
  def required_from
    self.required_from_recursive.flatten[(1..-1)]
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

  def image_path
    "/images/items/#{self.id}.png"
  end

  def self.accumulate_by_key(key)
    hash = {}
    self.where(is_material: false).each do |item|
      hash[item[key]] ||= []
      hash[item[key]].push(item)
    end
    hash
  end

  # これを素材として使う装備を(1階層のみ)掘る
  def dig_required
    Forge.where(material_item: self).map(&:forge_item)
  end

  # これを素材として使う装備一覧をツリーで返す
  def required_from_recursive
    return [self, []] if self.dig_required.empty?
    [self, self.dig_required.map(&:required_from_recursive)]
  end

  # これを装備するキャラたち
  def equip_characters
    characters = []
    characters.push(self.equips.map(&:character))
    self.required_from.each do |item|
      characters.push(item.equips.map(&:character))
    end
    characters.flatten.uniq
  end
end
