class PagesController < ApplicationController
  def home
    @root_categories = Category.where(ancestry: nil)
    @recipes = Recipe.includes([:user, :recipe_categories, :categories]).with_attached_image.recent
  end
end
