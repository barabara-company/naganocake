class OrderDetail < ApplicationRecord
  belongs_to :order, foreign_key: "orders_id"
  belongs_to :item, foreign_key: "item_id"
  
  enum making_status: { not_possible: 0, pending: 1, in_production: 2, completed: 3 }

  # hogehoge_id	DBレベルに近く、単純で高速	存在しないIDでもバリデ通る
  #	hogehoge 関連先が存在するかも確認できる	少しだけ遅い（無視できるレベル）関連先が存在しないと困るならこっち
  validates :item, presence: true
  validates :order, presence: true

  validates :price, presence: true
  validates :amount, presence: true
  validates :making_status, presence: true

  def subtotal
    price * amount
  end


end

