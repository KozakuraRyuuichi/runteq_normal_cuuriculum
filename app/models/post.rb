class Post < ApplicationRecord
  mount_uploader :posts_image, ImageUploader

  validates :title, length: { maximum: 255 }
  validates :content, length: { maximum: 65535 }
  validates :title, :content, presence: true
  
  # userモデルと紐付け、user消したら投稿も消える
  belongs_to :user
  validates :user, presence: true

  # 投稿消したらコメントも消える
  has_many :comments, dependent: :destroy
end
