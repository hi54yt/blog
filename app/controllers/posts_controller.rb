class PostsController < ApplicationController
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to '/home', notice: '创建成功'}
      else
        format.html { render action: 'new' }
      end
    end
  end
  
  private
  
  def post_params
    params.require(:post).permit(:title, :content)
  end
end
