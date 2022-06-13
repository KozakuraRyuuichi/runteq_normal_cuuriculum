class LikesController < ApplicationController
  def create
    post = Post.find params[:post_id]
    current_user.like(post)
    redirect_to posts_path, success: 'liked post.'
  end

  def destroy
    post = Post.find params[:post_id]
    current_user.unlike(post)
    redirect_to posts_path, success: 'unliked post.'
  end
end
