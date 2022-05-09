class AddImageToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :posts_image, :string
  end
end
