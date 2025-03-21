class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!
  def new
    @order = Order.new
    @addresses = current_customer&.addresses
    @customer = current_customer
  end
 
  def confirm
    session[:order_params] = params[:order] if params[:order].present?

    if session[:order_params].present?
      order_params = session[:order_params].permit!.to_h.symbolize_keys
      order_params[:payment_method] = order_params[:payment_method].to_i
      @order = Order.new(order_params.except( :address_id, :new_postal_code, :new_address, :new_name))
  # byebug
      case order_params[:address_option]
      when "registered"
        @order.postal_code = current_customer.postal_code
        @order.address = current_customer.address
        @order.name = "#{current_customer.last_name} #{current_customer.first_name}"
      when "saved"
        address = current_customer.addresses.find_by(id: order_params[:address_id])
        if address
          @order.postal_code = address.postal_code
          @order.address = address.address
          @order.name = address.name
        end
      when "new"
        @order.postal_code = order_params[:new_postal_code]
        @order.address = order_params[:new_address]
        @order.name = order_params[:new_recipient_name]
      end

      # address_optionをorderに設定
      @order.address_option = order_params[:address_option]  # ここで設定


    else
      flash[:alert] = "注文情報が見つかりません"
      redirect_to new_order_path and return
    end
  
    @cart_items = current_customer.cart_items
  
    @cart_total_price = @cart_items.sum { |cart_item| cart_item.item.price * cart_item.amount }
    @order.shipping_cost ||= 800 
    @order.total_payment = @cart_total_price + @order.shipping_cost
# beybug

  end
  
  

  def thanks
  end
 
  def create
    @order = Order.new(order_params)
    @order.customer = current_customer
    @order.shipping_cost = 800
    @order.total_payment = 1000
#     Rails.logger.debug "=== PARAMS: #{params.inspect} ==="
# byebug
    case params[:order][:address_option]
    when "registered"
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = "#{current_customer.last_name} #{current_customer.first_name}"
    when "saved"
      address = current_customer.addresses.find_by(id: params[:order][:address_id])
      if address
        @order.postal_code = address.postal_code
        @order.address = address.address
        @order.name = address.name
      else
        flash[:alert] = "住所を選択してください"
        render :new and return
      end
    when "new"
      if params[:order][:new_postal_code].present? && params[:order][:new_address].present? && params[:order][:new_recipient_name].present?
        @order.postal_code = params[:order][:new_postal_code]
        @order.address = params[:order][:new_address]
        @order.name = params[:order][:new_recipient_name]
      else
        flash[:alert] = "新しい住所を入力してください"
        render :new and return
      end
    else
      flash[:alert] = "住所の選択が必要です"
      render :new and return   #どうしてもここを踏んでしまう!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    end
  
    # if @order.save
    #   session[:order_params] = @order.attributes.symbolize_keys
    #   redirect_to orders_thanks_path

    # else
    #   flash[:alert] = "注文の保存に失敗しました: #{@order.errors.full_messages.join(", ")}"
    #   render :new
    end
  end
  
  
 
  def index
  end
 
  def show
  end

  private
  # def order_params
    # params.require(:order).permit(:payment_method, :address_option, :address_id, :new_postal_code, :new_address, :new_recipient_name)
  # end

  def order_params
    params.require(:order).permit(
      :postal_code,
      :address,
      :name,
      :shipping_cost,
      :total_payment,
      :address_option,
      :new_postal_code,
      :new_address,
      :new_name,
      :payment_method
          )
  end
  
end
