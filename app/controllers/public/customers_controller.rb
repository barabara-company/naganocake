class Public::CustomersController < ApplicationController

  before_action :authenticate_customer!  #ログインしてなかったらログイン画面へ移行

  def show
    @customer = current_customer
  end
    
  def edit
    @customer = current_customer
  end 

  def update
    current_customer.update
    redirect_to customer_path(current_customer)
  end
    
  def unsubscribe
  end
    
  def withdraw
    current_customer.update(is_active: false) #会員ステータスをfalseに変更
    reset_session #ログアウト処理
    redirect_to root_path
  end
end
