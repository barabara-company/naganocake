class Admin::OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update]

  def show
    @cust
  end

  def update
    if @order.update(order_params)
      redirect_to admin_order_path(@order), notice: "注文ステータスを更新しました"
    else
      flash[:alert] = "更新に失敗しました"
      render :show
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end

end
