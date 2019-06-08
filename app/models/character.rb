# == Schema Information
#
# Table name: characters
#
#  id             :integer          not null, primary key
#  name           :string           default("0"), not null
#  initial_rarity :integer          default(0), not null
#  place          :integer          default(NULL), not null
#  position       :decimal(, )      default(0.0), not null
#  role           :integer          default(NULL), not null
#

class Character < ApplicationRecord
  has_many :equips
  enum place: { front: 1, middle: 2, back: 3 }
  enum role: { attacker: 1, magic_attacker: 2, defender: 3, healer: 4}

  RANK_DIFFS_KEY = "rank_diffs"

  def max_rank
    equips.order(rank: :desc).first.rank
  end

  # ランクを上げた際のパラメータ差分
  def rank_diffs(rank)
    cache_or_block("#{RANK_DIFFS_KEY}:#{self.id}:#{rank}") do
      diffs = {}
      # ぜんぜんDRYじゃないので直したいがそういう頭の回り方をする日じゃないので保留
      # あとこれwherechainが更新されちゃってpreloadが効かなくなるのでN+1誘発しやすい書き方なのも良くない
      equips.where(rank: rank).each do |equip|
        equip&.item&.parameters&.map{|key, value| diffs[key] ||= 0; diffs[key] -= value}
      end

      equips.where("rank > #{rank}").where("rank < #{self.max_rank}").each do |equip|
        equip&.item&.parameters&.map{|key, value| diffs[key] ||= 0; diffs[key] += value}
      end

      equips.where(rank: self.max_rank).each do |equip|
        equip&.item&.parameters&.map{|key, value| diffs[key] ||= 0; diffs[key] += value * 2}
      end
      diffs
    end
  end

  def accumulate_equips_by_key(key)
    hash = {}
    self.equips.each do |item|
      hash[item[key]] ||= []
      hash[item[key]].push(item)
    end
    hash
  end

  def total_equips
    hash = {}
    # 愚直に定義どおり書くとこうなんだけど、こうやって関連を引いてしまうとN+1か過剰なpreload不可避なので
    # グローバルにForgeからwhereで引いて足してくほうがいいんだと思う
    self.equips.each do |equip|
      item = equip.item
      item&.accumulate_all_materials&.each do |forge|
        hash[forge.material_item] ||= 0
        hash[forge.material_item] += forge.count
      end
    end
    hash
  end

  def image_path
    "/images/characters/#{self.id}.png"
  end

  def important_parameters
    # TP上昇は誰にとっても重要
    parameters = [:tpgain]

    # 役割に重要なパラメータを追加
    case role
    when "attacker"
      parameters += [:atk, :cri]
    when "magic_attacker"
      parameters += [:matk, :mcri]
    when "defender"
      parameters += [:hp, :def, :mdef, :eva]
    when "healer"
      parameters += [:healgain, :matk]
    end
    parameters
  end

  def important?(parameter_symbol)
    parameter_symbol.in? important_parameters
  end
end
