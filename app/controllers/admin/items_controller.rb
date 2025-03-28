class Admin::ItemsController < ApplicationController
  before_action :is_matching_login_admin

  def index
    @items = Item.page(params[:page]).per(10)
    
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to admin_item_path(@item)
    else
      flash.now[:alert] = "登録に失敗しました" 
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to admin_item_path(@item)
    else
      flash.now[:alert] = "更新に失敗しました" 
      render :edit
    end
  end

  private

  def item_params
    params.require(:item).permit(
    :image,
    :name,
    :introduction,
    :genre_id,
    :price,
    :is_active)
  end

  def is_matching_login_admin
    unless current_admin
      redirect_to new_admin_session_path, alert: "管理者としてログインしてください"
    end
  end


end
