class ItemsController < ApplicationController
  def index
    @item = Item.new
    @items = Item.all
  end

  def show
    @item = Item.find_by(id: params[:id])
  end
end
