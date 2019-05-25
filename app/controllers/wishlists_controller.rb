class WishlistsController < ApplicationController
  def index
    @selected_items = item_ids.map{|item_id| Item.find_by(id: item_id)}.compact
    @items_sorted = Item.accumulate_by_key(:rank)
    @index_lambda = ->(x) {"rank #{x}"}
    @serving_stages = Stage.serving_stages(@selected_items)
  end

  def item_ids
    params[:item_ids]&.split(",")&.map(&:to_i)&.reject{|x| x==0} || []
  end
end
