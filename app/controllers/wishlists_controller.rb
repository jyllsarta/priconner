class WishlistsController < ApplicationController
  def index
    @items_sorted = Item.accumulate_by_key(:rank)
    @index_lambda = ->(x) {"rank #{x}"}
  end
end
