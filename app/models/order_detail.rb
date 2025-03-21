class OrderDetail < ApplicationRecord
  belongs_to :order, foreign_key: "orders_id"
  belongs_to :item, foreign_key: "item_id"
end
