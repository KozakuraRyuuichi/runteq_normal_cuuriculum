class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :last_name, length: { maximum: 255 }, if: -> { new_record? || changes[:crypted_password] }
  validates :first_name, length: { maximum: 255 }, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true
  validates :last_name, :first_name, :email, presence: true

  # ユーザー消したら投稿も消える
  has_many :posts, dependent: :destroy
  # ユーザー消したらコメントも消える
  has_many :comments, dependent: :destroy
  # ユーザー消したらブックマーク消える
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_posts, through: :bookmarks, source: :post

  def own?(object)
    id == object.user_id
  end

  def bookmark(post)
    bookmark_posts << post
  end

  def unbookmark(post)
    bookmark_posts.delete(post)
  end

  def bookmark?(post)
    bookmark_posts.include?(post)
    # Bookmark.where(user_id: id, post_id: post.id).exists?と同じ
end