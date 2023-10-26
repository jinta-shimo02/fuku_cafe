class Review < ApplicationRecord
  belongs_to :user
  belongs_to :shop

  enum rating: { one: 1, two: 2, three: 3, four: 4, five: 5 }

  validates :content, presence: true, length: { maximum: 155 }

  def rating_as_number
    Review.ratings[rating]
  end
end
