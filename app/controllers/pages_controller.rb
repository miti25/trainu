class PagesController < ApplicationController
  def home
    @recipes = current_user.recipes.recent
  end
end
