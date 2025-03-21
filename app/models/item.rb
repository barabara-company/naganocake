class Item < ApplicationRecord

  has_one_attached :image

  has_many :cart_items, dependent: :destroy
  has_many :order_details, dependent: :destroy
  
  belongs_to :genre

  # 税込金額用メソッド 消費税10%計算
  def tax_included_price
    (price * 1.1)
  end

end
