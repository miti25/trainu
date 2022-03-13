class FavoritesController < ApplicationController
  def index
    @recipes = current_user.favorite_recipes.includes(%i[user recipe_categories categories]).with_attached_image
  end

  def create
    @favorite = current_user.favorites.create(recipe_id: params[:recipe_id])
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @favorite = Favorite.find_by(recipe_id: params[:recipe_id], user_id: current_user.id)
    @favorite.destroy
    redirect_back(fallback_location: root_path)
  end
end
