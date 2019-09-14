class WelcomeController < ApplicationController
  def index
    @post  = Mechanical::Model::Post.new
    @posts = Mechanical::Model::Post.all
  end

  def submit_post
    @post = Mechanical::Model::Post.new(params.require(:post).permit!)
    @post.user = User.first
    @post.save
    if @post.save
      redirect_to root_path
    else
      @posts = Mechanical::Model::Post.all
      render :index
    end
  end

end
