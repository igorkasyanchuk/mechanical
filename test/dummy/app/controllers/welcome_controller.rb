class WelcomeController < ApplicationController
  def index
    @user = Mechanical['User'].form.new
    @post = Mechanical['Post'].form.new

    @user.age = 77
    @post.published_on = Date.current

    load_all
  end

  def submit_user
    @user = Mechanical['User'].form.new(params.require(:user).permit!)
    if @user.save
      redirect_to root_path
    else
      @post = Mechanical['Post'].form.new
      load_all
      render :index
    end
  end

  def submit_post
    @post = Mechanical['Post'].form.new(params.require(:post).permit!)
    if @post.save
      redirect_to root_path
    else
      @user = Mechanical['User'].form.new
      load_all
      render :index
    end
  end

  def load_all
    @posts = Mechanical['Post'].model.all
    @users = Mechanical['User'].model.all
  end
end
