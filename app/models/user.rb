class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  after_create :create_initial_list

  has_many :shop_saved_lists, dependent: :destroy

  enum role: { general: 0, admin: 1 }

  validates :name, presence: true, length: { maximum: 255 }

  private

  def create_initial_list
    shop_saved_lists.create(name: 'お気に入り')
  end
end
