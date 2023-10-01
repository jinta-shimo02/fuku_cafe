class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :shop_saved_lists, dependent: :destroy

  enum role: { general: 0, admin: 1 }

  validates :name, presence: true, length: { maximum: 255 }
end
