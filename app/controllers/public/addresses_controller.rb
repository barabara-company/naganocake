module Public
  class AddressesController < ApplicationController
    before_action :set_address, only: [:edit, :update, :destroy]
    before_action :is_matching_login_customer
    before_action :authenticate_customer!
    
      def index
      @addresses = Address.all
      @new_address = Address.new
    end

    def create
      @address = Address.new(address_params)
      @address.customer_id = current_customer.id
      if @address.save
        redirect_to addresses_path
      else
        @addresses = Address.all
        flash.now[:alert] = "登録に失敗しました"
        render :index, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @address.update(address_params)
        redirect_to addresses_path
      else
        flash.now[:alert] = "更新に失敗しました"
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @address.destroy
      redirect_to addresses_path
    end

    private

    def set_address
      @address = Address.find(params[:id])
    end


    def is_matching_login_customer
      unless current_customer
        redirect_to root_path, alert: "不正なログインです"
      end
    end

    def address_params
      params.require(:address).permit(:customer_id, :postal_code, :address, :name)
    end
  end
end