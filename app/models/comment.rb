class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :body, length: { maximum: 65535 }
  validates :body, presence: true

end
