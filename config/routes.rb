Rails.application.routes.draw do

  devise_for :admins
  devise_for :customers, controllers: { sessions: 'public/devise/sessions' }

  # 会員側のルーティング
  scope module: :public do
    root :to =>"homes#top"
    get "/about"=>"homes#about"

    resources :items, only: [:index,:show]

    get "/customers/unsubscribe"=>"customers#unsubscribe"
    patch "/customers/withdraw"=>"customers#withdraw"
    resources :customers, only: [:show,:edit,:update]

    delete "/cart_items/destroy_all"=>"cart_items#destroy_all"
    resources :cart_items, only: [:index,:update,:create,:destroy]
    
    post "/oreders/confirm"=>"orders#confirm"
    get "/oreders/thanks"=>"orders#thanks"
    resources :orders, only: [:new,:create,:index,:show]
    
    resources :addresses, only: [:index,:edit,:create,:update,:destroy]
  end
  
  # 管理者側のルーティング
  namespace :admin do
    root to: 'homes#top' # /admin → admin/homes#top
    resources :items, except: [:destroy] # 商品管理
    resources :genres, only: [:index, :create, :edit, :update] # ジャンル管理
    resources :customers, only: [:index, :show, :edit, :update] # 顧客管理
    resources :orders, only: [:show, :update] # 注文管理
    resources :order_details, only: [:update] # 注文詳細（製作ステータス更新）
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

