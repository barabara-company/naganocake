class Admin::HomesController < ApplicationController
  before_action :is_matching_login_admin

  def top
    @orders = Order.includes(:customer, :order_details).order(created_at: :desc).page(params[:page]).per(10)
   end

   def is_matching_login_admin
    unless current_admin
      redirect_to new_admin_session_path, alert: "管理者としてログインしてください"
    end
  end

end
