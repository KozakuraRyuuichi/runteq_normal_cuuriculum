class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true
  validates :email, presence: true
  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name, presence: true, length: { maximum: 255 }

  def mine?(object)
    # 呼び出し元のオブジェクトのIDを示す self.id を省略した記法。
    # @user.mine?(object)のように利用すると、object.user_id と @user.id を比較する。
    object.user_id == id
  end

  def like(post)
    liked_posts << post
  end

  def unlike(post)
    liked_posts.delete post
  end

  def like?(post)
    liked_posts.include? post
  end
end
