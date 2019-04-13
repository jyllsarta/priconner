class ItemsController < ApplicationController
  def index
    @item = Item.new
    @items_sorted_by_rank = Item.accumulate_by_key(:rank)
  end

  def show
    @item = Item.find_by(id: params[:id])
  end
end
