class ApplicationController < ActionController::Base
  helper_method :current_user, :admin_or_himself?, :require_admin_or_himself
  before_action :login_required

  private

  def login_required
    redirect_to login_path unless current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def admin_or_himself?
    current_user.admin? || owned_user?
  end

  def require_admin_or_himself
    redirect_to root_path unless admin_or_himself?
  end
end
