class Admin::UsersController < ApplicationController
  include SessionsHelper

  skip_before_action :login_required, only: %i[show new create]
  before_action :require_admin_or_himself, only: %i[edit update destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      redirect_to admin_user_path(@user), notice: "ユーザー「#{@user.name}」を登録しました"
    else
      render :new
    end
  end

  def edit
    set_user
  end

  def update
    set_user
    if @user.update(user_params)
      redirect_to admin_user_url, notice: "ユーザー「#{@user.name}を更新しました"
    else
      render :new
    end
  end

  def destroy
    set_user
    @user.destroy
    redirect_to root_path, notice: "ユーザー「#{@user.name}」を削除しました"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def owned_user?
    user = User.find(params[:id])
    current_user == user
  end
end
