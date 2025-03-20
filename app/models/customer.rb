class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :cart_items, dependent: :destroy


  # is_activeがtrueでないとログインできない用に設定
  def active_for_authentication?
    super && is_active?
  end

  has_many :orders,  dependent: :destroy
  has_many :addresses,  dependent: :destroy

  validates :last_name, :first_name, :last_name_kana, :first_name_kana, :postal_code, :address, :telephone_number, presence: true
  validates :postal_code, format: { with: /\A\d{7}\z/, message: "must be 7 digits" }
  validates :telephone_number, format: { with: /\A\d{10,11}\z/, message: "is invalid" }

  
end
