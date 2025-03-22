class OrderDetail < ApplicationRecord
  belongs_to :order, foreign_key: "orders_id"


  

  enum production_status: { not_possible: 0, pending: 1, in_production: 2, completed: 3 }

  def subtotal
    unit_price * quantity
  end

  belongs_to :item, foreign_key: "item_id"

end
