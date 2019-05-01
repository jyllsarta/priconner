class CharactersController < ApplicationController
  def index
    @character = Character.new
    @front_characters = Character.where(place: Character.places[:front]).order(position: :asc)
    @middle_characters = Character.where(place: Character.places[:middle]).order(position: :asc)
    @back_characters = Character.where(place: Character.places[:back]).order(position: :asc)
  end

  def show
    @character = Character.preload(equips: [:item]).find_by(id: params[:id])
    # 金装備以上に絞り込む
    @total_equips = @character.total_equips.select{|item, _| item.rank >= 7}.sort_by{|item, _| item.rank}
  end
end
