class WishlistsController < ApplicationController
  def index
    @selected_item_ids = item_ids
    @items_sorted = Item.accumulate_by_key(:rank)
    @index_lambda = ->(x) {"rank #{x}"}
  end

  def item_ids
    params[:item_ids]&.split(",")&.map(&:to_i).reject{|x| x==0} || []
  end
end
