class WelcomeController < ApplicationController
  def index
    @user = Mechanical['User'].form.new
    @users = Mechanical['User'].model.all

    @post = Mechanical['Post'].form.new
    @posts = Mechanical['Post'].model.all
  end

  def submit
    @user = Mechanical['User'].form.new(params.require(:user).permit!)
    if @user.valid?
      @user.create
      redirect_to root_path
    else
      @users = Mechanical['User'].model.all
      render :index
    end
  end
end
