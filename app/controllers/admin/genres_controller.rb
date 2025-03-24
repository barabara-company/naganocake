class Admin::GenresController < ApplicationController
  before_action :is_matching_login_admin

  def index
    @genres = Genre.all
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to admin_genres_path
    else
      # ジャンルのindexへ
      @genres = Genre.all
      @genre = Genre.new(genre_params)
      flash.now[:alert] = "登録に失敗しました" 
      render :index
    end
  end

  def edit
    @genre = Genre.find(params[:id])  # 編集するジャンルを取得
  end

  def update
    @genre = Genre.find(params[:id])
    if @genre.update(genre_params)
      redirect_to admin_genres_path  # ジャンル一覧へリダイレクト
    else
      flash.now[:alert] = "更新に失敗しました" 
      render :edit  # 更新に失敗した場合は再度編集フォームを表示
    end
  end

  private

  def genre_params
    params.require(:genre).permit(:name)
  end

  def is_matching_login_admin
    unless current_admin
      redirect_to new_admin_session_path, alert: "管理者としてログインしてください"
    end
  end

end
