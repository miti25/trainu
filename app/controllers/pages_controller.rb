class PagesController < ApplicationController
  def home
    @recipes = current_user.recipes
  end
end
