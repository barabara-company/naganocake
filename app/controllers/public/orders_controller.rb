module Public
  class OrdersController < ApplicationController

    before_action :is_matching_login_customer
    before_action :authenticate_customer!
  
    def new
      @order = Order.new  # ここで @order を初期化
    end


    def confirm
      # customer_idを使ってカートアイテムを取得
      @cart_items = CartItem.where(customer_id: current_customer.id)
      @shipping_fee = 800 # 送料は800円で固定
      @selected_pay_method = params[:order][:pay_method]
    
      # 商品合計額の計算
      ary = []
      @cart_items.each do |cart_item|
        ary << cart_item.item.tax_included_price.floor * cart_item.amount  # 修正：quantity ではなく、amount を使用
      end
      @cart_items_price = ary.sum
    
      @total_price = @shipping_fee + @cart_items_price
      @address_type = params[:order][:address_type]

      # 新しい住所が選択されている場合に検証を行う
      if params[:order][:address_type] == "new_address"
        if params[:order][:new_post_code].blank? || params[:order][:new_address].blank? || params[:order][:new_name].blank?
          flash[:alert] = "新しいお届け先情報をすべて入力してください。"
          redirect_to new_order_path and return
        end
      end

      case @address_type
      when "member_address"
        @selected_address = current_customer.postal_code + " " + current_customer.address + " " + current_customer.last_name + current_customer.first_name
      when "registered_address"
        unless params[:order][:registered_address_id].blank?
          selected = Address.find(params[:order][:registered_address_id])
          @selected_address = selected.postal_code + " " + selected.address + " " + selected.name
        else
          flash[:alert] = "配送先住所を選択してください"
          redirect_to new_order_path and return
        end
      when "new_address"
        unless params[:order][:new_post_code].blank? && params[:order][:new_address].blank? && params[:order][:new_name].blank?
          @selected_address = params[:order][:new_post_code] + " " + params[:order][:new_address] + " " + params[:order][:new_name]
        else
          flash[:alert] = "配送先住所の作成に失敗しました"
          redirect_to new_order_path and return
        end
      end
    end
    
    def create
      @order = Order.new
      @order.customer_id = current_customer.id
      @order.shipping_cost = 800
      @cart_items = CartItem.where(customer_id: current_customer.id)
      ary = []
      
      @cart_items.each do |cart_item|
        ary << cart_item.item.price * cart_item.amount  # 修正：amount を使用
      end
      
      @cart_items_price = ary.sum
      @order.total_payment = @order.shipping_cost + @cart_items_price
      @order.payment_method = params[:order][:pay_method]
      if @order.payment_method == "credit_card"
        @order.status = 1
      else
        @order.status = 0
      end
    
      address_type = params[:order][:address_type]
      case address_type
      when "member_address"
        @order.postal_code = current_customer.postal_code
        @order.address = current_customer.address
        @order.name = current_customer.last_name + current_customer.first_name
      when "registered_address"
        selected = Address.find(params[:order][:registered_address_id])
        @order.postal_code = selected.postal_code
        @order.address = selected.address
        @order.name = selected.name
      when "new_address"
        @order.postal_code = params[:order][:new_post_code]
        @order.address = params[:order][:new_address]
        @order.name = params[:order][:new_name]
      end
    
      if @order.save
        if @order.status == 0
          @cart_items.each do |cart_item|
            OrderDetail.create!(orders_id: @order.id, item_id: cart_item.item.id, price: cart_item.item.price, amount: cart_item.amount, making_status: 0) # 修正：quantity -> amount
          end
        else
          @cart_items.each do |cart_item|
            OrderDetail.create!(orders_id: @order.id, item_id: cart_item.item.id, price: cart_item.item.price, amount: cart_item.amount, making_status: 1) # 修正：quantity -> amount
          end
        end
        @cart_items.destroy_all
        redirect_to orders_thanks_path
      else
        flash.now[:alert] = "登録に失敗しました"
        render :new
      end
    end
    
    def index
      @orders = Order.all
    end
   
    def show
      @order = Order.find(params[:id])
      @order_details = @order.order_details
    end
  
    def thanks
      # ありがとうページに表示する内容があればここに書く
    end
  end
end



