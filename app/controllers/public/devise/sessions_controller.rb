class Public::Devise::SessionsController < Devise::SessionsController
  layout 'application' # 必要なら別のレイアウトを指定

  def new
    super
  end

  def create
    super
  end

  def destroy
    super
  end
end

