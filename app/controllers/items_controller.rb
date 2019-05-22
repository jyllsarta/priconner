class ItemsController < ApplicationController
  def index
    case params[:sort_key]&.to_sym
    when :category
      @items_sorted = Item.accumulate_by_key(:category)
      @index_lambda = ->(x) {Item.category_texts.invert[x]}
    else
      @items_sorted = Item.accumulate_by_key(:rank)
      @index_lambda = ->(x) {"rank #{x}"}
    end
  end

  def by_category
    @item = Item.new
    @items_sorted_by_rank = Item.accumulate_by_key(:category)
  end

  def show
    @item = Item.find_by(id: params[:id])
    redirect_to item_path(@item.to_forged) if @item.is_material
  end
end
