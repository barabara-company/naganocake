class Admin::OrderDetailsController < ApplicationController
  before_action :set_order_detail, only: [:update]

  def update
    if @order_detail.update(order_detail_params)
      redirect_to admin_order_path(@order_detail.order), notice: "製作ステータスを更新しました"
    else
      flash.now[:alert] = "更新に失敗しました"
      render :show
    end
  end

  private

  def set_order_detail
    @order_detail = OrderDetail.find(params[:id])
  end

  def order_detail_params
    params.require(:order_detail).permit(:making_status)
  end
  

end
