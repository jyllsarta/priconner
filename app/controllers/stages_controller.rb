class StagesController < ApplicationController
  def index
    @stage = Stage.new
    @stages = Stage.preload(drops: [:item]).order(:area).order(:is_hard).order(:location)
  end

  def show
    @stage = Stage.find_by(id: params[:id])
  end
end
