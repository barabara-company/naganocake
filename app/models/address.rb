class Address < ApplicationRecord
  belongs_to :customer

  # customer_id	DBレベルに近く、単純で高速	存在しないIDでもバリデ通る
  # customer	関連先が存在するかも確認できる	少しだけ遅い（無視できるレベル）関連先が存在しないと困るならこっち
  validates :customer, presence: true

  
  validates :postal_code, presence: true, format: { with: /\A\d{7}\z/, message: 'は7桁の数字で入力してください' }
  validates :address, presence: true
  validates :name, presence: true

  def address_display
    '〒' + postal_code + '' + address + '' + name
  end
  attr_accessor :address_option
end
