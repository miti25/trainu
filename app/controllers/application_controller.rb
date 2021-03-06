class ApplicationController < ActionController::Base
  helper_method :current_user, :admin_or_himself?, :require_admin_or_himself
  before_action :login_required, :set_search

  private

  def login_required
    redirect_to login_path, notice: 'ログインしてください' unless current_user
  end

  def set_search
    @q = Recipe.includes(%i[user recipe_categories categories]).with_attached_image.ransack(params[:q])
    @search_recipes = @q.result(distinct: true)
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def admin_or_himself?
    current_user&.admin? || owned_user?
  end

  def require_admin_or_himself
    redirect_to root_path unless admin_or_himself?
  end
end
