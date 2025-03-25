class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_details, foreign_key: "orders_id", dependent: :destroy
  attr_accessor :address_option
  enum status: { 
    waiting_for_payment: 0, 
    payment_confirmed: 1, 
    in_production: 2, 
    preparing_for_shipment: 3, 
    shipped: 4 
  }

  enum payment_method: {
    credit_card: 0,
    bank_transfer: 1
  }


  after_update :update_making_status, if: :saved_change_to_status?

  # customer_id	DBレベルに近く、単純で高速	存在しないIDでもバリデ通る
  # customer	関連先が存在するかも確認できる	少しだけ遅い（無視できるレベル）関連先が存在しないと困るならこっち
  validates :customer, presence: true
  validates :name, presence: true
  validates :postal_code, presence: true
  validates :address, presence: true
  validates :shipping_cost, presence: true
  validates :total_payment, presence: true
  validates :payment_method, presence: true
  validates :status, presence: true

  def order_address_display
    '〒' + postal_code + ' ' + address + ' ' + name
  end

  private

  # 入金確認の際に製作ステータスを「製作待ち」に更新
  def update_making_status
    if payment_confirmed? # 注文ステータスが「入金確認」の場合
      order_details.update_all(making_status: :pending) # 製作ステータスを「製作待ち」に変更
    end
  end
end

