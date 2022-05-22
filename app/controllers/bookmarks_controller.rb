class BookmarksController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    current_user.bookmark(post)
    rediurect_back fallback_location: root_path, succes: t('default.message.bookmark')
  end

  def destroy
    post = current_user.bookmarks.find(params[:id]).post
    current_user.unbookmark(post)
    rediurect_back fallback_location: root_path, success: t('default.message.unbookmark')
  end
end
