class Public::ItemsController < ApplicationController
  def index
    # gem kaminari pageメソッド使用 1ページあたり8件表示
    @items = Item.page(params[:page]).per(8)
    @items2 = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end
end
