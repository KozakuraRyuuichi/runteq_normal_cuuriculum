class Post < ApplicationRecord
  validates :title, length: { maximum: 255 }
  validates :content, length: { maximum: 255 }
  validates :title, :content, presence: true
  
  # userモデルと紐付け、user消したら投稿も消える
  belongs_to :user
  validates :user, presence: true
end
