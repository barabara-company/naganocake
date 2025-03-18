class Public::CartItemsController < ApplicationController

  before_action :authenticate_customer!

  def index
    # current_customerに関連するカートアイテムを取得
    @cart_items = current_customer.cart_items
  end
  def create
    @item = Item.find(params[:item_id]) # アイテムを取得
    amount = params[:amount].to_i # 数量を取得

    # カートにアイテムを追加（セッションを使用してカートを管理）
    session[:cart] ||= []
    session[:cart] << { item_id: @item.id, amount: amount }

    redirect_to cart_items_path # カートページへリダイレクト
  end
  
  def update
  end

  def destroy
  end

  def destroy_all
  end

end
