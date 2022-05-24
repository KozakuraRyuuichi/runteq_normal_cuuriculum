class PostsController < ApplicationController
  # before_action :require_login, only: %i[new create edit update destroy]

  def index
    @posts = Post.all.includes(:user).order(created_at: :desc)
    # @posts = Post.all.includes([:user, :bookmarks]).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render 'new'
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), success: t('default.message.updated', item: Post.model_name.human)
    else
      flash.now[:danger] = t('default.message.not_updated', item: Post.model_name.human)
      render 'edit'
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy!
    redirect_to posts_path, success: t('default.message.deleted', item: Post.model_name.human)
  end


  def bookmarks
    @bookmark_posts =current_user.bookmark_posts.includes(:user).order(created_at: :desc)
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :posts_image, :posts_image_cache)
  end
end
