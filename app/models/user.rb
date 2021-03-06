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

  def own?(object)
    id == object.user_id
  end
end