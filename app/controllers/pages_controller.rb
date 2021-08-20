class PagesController < ApplicationController
  def home
    @root_categories= Category.where(ancestry: nil)
    @recipes = Recipe.all.recent
  end
end
