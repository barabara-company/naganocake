class Admin::CustomersController < ApplicationController
  before_action :is_matching_login_admin

  def show
    @customer = Customer.find(params[:id])
  end

  def index
    @customers = Customer.all
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    params[:customer][:is_active] = params[:customer][:is_active] == "true"
    if @customer.update(customer_params)
      redirect_to admin_customer_path(@customer), notice: "更新に成功しました"
    else
      flash.now[:alert] = "更新に失敗しました" 
      render "edit"
    end
  end

  private
  def customer_params
    params.require(:customer).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :postal_code, :address, :telephone_number,:email,:is_active)
  end

  def is_matching_login_admin
    unless current_admin
      redirect_to new_admin_session_path, alert: "管理者としてログインしてください"
    end
  end

end
