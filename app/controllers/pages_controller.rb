class PagesController < ApplicationController
  def home
    @recipes = Recipe.all.recent
  end
end
