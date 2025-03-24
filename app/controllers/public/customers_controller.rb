class Public::CustomersController < ApplicationController

  before_action :authenticate_customer!  #ログインしてなかったらログイン画面へ移行

  def show
    @customer = current_customer
  end
    
  def edit
    @customer = current_customer
  end 

  def update
    if current_customer.update(customer_params)
      redirect_to customer_path(current_customer)
    else
      flash.now[:alert] = "更新に失敗しました"
      render :edit
    end
  end  

  def unsubscribe
  end
    
  def withdraw
    current_customer.update(is_active: false) #会員ステータスをfalseに変更
    reset_session #ログアウト処理
    flash[:notice] = "退会しました"
    redirect_to root_path
  end

  private
  def customer_params
    params.require(:customer).permit(
    :last_name,
    :first_name,
    :last_name_kana,
    :first_name_kana,
    :postal_code,
    :address,
    :telephone_number,
    :email)
  end
end
