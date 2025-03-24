class Public::CartItemsController < ApplicationController
  before_action :is_matching_login_customer
  before_action :authenticate_customer!
  
  def index
    @cart_items = current_customer.cart_items
  end
  
  def create
    # params[:item][:item_id] を使って、アイテムを検索
    @item = Item.find(params[:item][:item_id])
    amount = params[:item][:amount].to_i

    # カートアイテムがすでに存在する場合は数量を追加、存在しない場合は新しく作成
    @cart_item = current_customer.cart_items.find_or_initialize_by(item_id: @item.id)
    @cart_item.amount = (@cart_item.amount || 0) + amount

    if @cart_item.save
      redirect_to cart_items_path, notice: 'カートに商品を追加しました。'
    else
      redirect_to @item, alert: 'カートに追加できませんでした。'
    end
  end

  def update
    @cart_item = CartItem.find(params[:id])
    if @cart_item.update(cart_item_params)
      redirect_to cart_items_path, notice: "数量が更新されました"
    else
      render :index, alert: "数量の更新に失敗しました"
    end
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to cart_items_path, notice: "商品をカートから削除しました"
  end

def destroy_all
  current_customer.cart_items.destroy_all
  redirect_to cart_items_path, notice: "カートを空にしました"
end

  private

  def is_matching_login_customer
    unless current_customer
      redirect_to root_path, alert: "不正なログインです"
    end
  end


  def cart_item_params
    params.require(:cart_item).permit(:amount)
  end
end
