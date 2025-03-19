class Public::CartItemsController < ApplicationController

  before_action :authenticate_customer!

  def index
    # 現在の顧客に紐づく cart_items を取得（カートがなければ新しい CartItem を作成）
    @cart_items = current_customer.cart_items
  
    # カートが空の場合、新しい CartItem を作成
    if @cart_items.empty?
      # ここでは仮に最初のアイテムを追加しています。適切なアイテムを選んでください。
      default_item = Item.first # 仮に最初の商品を選択
      current_customer.cart_items.create(item: default_item, amount: 1)
      @cart_items = current_customer.cart_items
    end
  end
  
  def create
    @cart = current_customer.cart || current_customer.create_cart
    @item = Item.find(params[:item_id])
    amount = params[:amount].to_i

    # すでにカートにあるか確認
    cart_item = @cart.cart_items.find_by(item_id: @item.id)

    if cart_item
      # 既にあるなら数量を追加
      cart_item.update(amount: cart_item.amount + amount)
    else
      # なければ新規作成
      @cart.cart_items.create(item: @item, amount: amount)
    end

    redirect_to cart_items_path, notice: "カートに追加しました"
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
  current_customer.cart.cart_items.destroy_all
  redirect_to cart_items_path, notice: "カートを空にしました"
end

  private

  def cart_item_params
    params.require(:cart_item).permit(:amount)
  end
end
