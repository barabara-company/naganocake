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
  
  after_update :update_order_status, if: :saved_change_to_making_status?

  private

  # 製作ステータスの変更に応じて注文ステータスを更新
  def update_order_status
    if in_production? # 1つでも「製作中」なら注文ステータスを「製作中」に変更
      order.update(status: :in_production)
    elsif order.order_details.all? { |detail| detail.completed? } # 全て「製作完了」なら注文ステータスを「発送準備中」に変更
      order.update(status: :preparing_for_shipment)
    end
  end

end

