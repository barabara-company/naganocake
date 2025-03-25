class Admin::OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update]
  before_action :is_matching_login_admin

  def show
    @order = Order.find(params[:id])  # 注文情報を取得
  end
  

  def update
    if @order.update(order_params)
      redirect_to admin_order_path(@order), notice: "注文ステータスを更新しました"
    else
      flash.now[:alert] = "更新に失敗しました"
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

  
  def is_matching_login_admin
    unless current_admin
      redirect_to new_admin_session_path, alert: "管理者としてログインしてください"
    end
  end

end
