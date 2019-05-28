class RankDiffsController < ApplicationController
  def index
    @front_characters = Character.where(place: Character.places[:front]).order(position: :asc)
    @middle_characters = Character.where(place: Character.places[:middle]).order(position: :asc)
    @back_characters = Character.where(place: Character.places[:back]).order(position: :asc)
  end
end
