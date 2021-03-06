class PagesController < ApplicationController
  skip_before_action :login_required

  def home
    @root_categories = Category.where(ancestry: nil)
    @recipes = Recipe.includes(%i[user recipe_categories categories]).with_attached_image.recent
  end
end
