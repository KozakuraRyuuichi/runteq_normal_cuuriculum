class CommentsController < ApplicationController
  def create
    # @post = Post.find(params[:post_id])
    # @comment = @post.user.comments.build(comment_params)
    # @comment.user_id = current_user.id
    comment = current_user.comments.build(comment_params)
    if comment.save
      # redirect_to post_path(@post), success: t('.success')
      redirect_to post_path(comment.post), success: t('default.message.created', item: Comment.model_name.human)
    else
      redirect_to post_path(comment.post), danger: t('default.message.not_created', item: Comment.model_name.human)
    end
  end

  # def destroy
  #   @post = Post.find(params[:post_id])
  #   @comment = @post_id.comments.build(comment_params)
  #   @comment.user_id = current_user.id
  #   @comment.destroy!
  # end

  private

  def comment_params
    # params.require(:comment).permit(:body)
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end
end
