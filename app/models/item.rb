class Item < ApplicationRecord

  has_one_attached :image

  has_many :cart_items, dependent: :destroy
  has_many :order_details, dependent: :destroy
  
  belongs_to :genre

  has_many :order_details



  # genre_id	DBレベルに近く、単純で高速	存在しないIDでもバリデ通る
  # genre	関連先が存在するかも確認できる	少しだけ遅い（無視できるレベル）関連先が存在しないと困るならこっち
  validates :genre, presence: true

  validates :name, presence: true
  validates :introduction, presence: true
  validates :price, presence: true
  validates :is_active, inclusion: { in: [true, false] }
  validates :image, presence: true
  # 税込金額用メソッド 消費税10%計算
  def tax_included_price
    (price * 1.1)
  end

end
