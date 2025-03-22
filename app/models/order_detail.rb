class OrderDetail < ApplicationRecord
  belongs_to :order, foreign_key: "orders_id"
  belongs_to :item, foreign_key: "item_id"
  
  enum making_status: { not_possible: 0, pending: 1, in_production: 2, completed: 3 }

  def subtotal
    price * amount
  end
end

