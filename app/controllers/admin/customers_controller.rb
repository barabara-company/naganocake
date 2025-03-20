class Admin::CustomersController < ApplicationController
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
      redirect_to admin_customer_path(@customer), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  private
  def customer_params
    params.require(:customer).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :postal_code, :address, :telephone_number,:email,:is_active)
  end
end
