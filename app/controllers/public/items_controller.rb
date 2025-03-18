class Public::ItemsController < ApplicationController
  def index
    # gem kaminari pageメソッド使用 1ページあたり8件表示
    @items = Item.page(params[:page]).per(8)
  end

  def show
    @item = Item.find(params[:id])
  end
end
