class Item < ApplicationRecord

  has_one_attached :image

  has_many :cart_items, dependent: :destroy

  belongs_to :genre

  # 税込金額用メソッド 消費税10%計算
  def tax_included_price
    # floorで小数点以下を切り捨て
    (price * 1.1).floor
  end

  # 税込金額に3行ごとにカンマをつけるメソッド
  def formatted_price
    number_with_delimiter(tax_included_price)
  end


end
