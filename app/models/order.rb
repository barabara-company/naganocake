class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_details, foreign_key: "orders_id", dependent: :destroy

  enum status: { 
    waiting_for_payment: 0, 
    payment_confirmed: 1, 
    in_production: 2, 
    preparing_for_shipment: 3, 
    shipped: 4 
  }

  enum payment_method: { credit_card: 0, bank_transfer: 1 }

end
