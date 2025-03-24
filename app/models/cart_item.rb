class CartItem < ApplicationRecord
  belongs_to :customer
  belongs_to :item

  validates :item, presence: true
  validates :customer, presence: true
  validates :amount, presence: true

end
