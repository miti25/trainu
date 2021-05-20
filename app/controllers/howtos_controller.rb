class HowtosController < ApplicationController

  def create
    howto = Howto.new(howto_params)
    howto.recipe_id = params[:recipe_id]
    if howto.save
      session[:howtos_ids] = session[:howtos_ids].push(howto.id)
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    howto = Howto.find(params[:id])
    session[:howtos_ids] ||= howto.recipe.howtos.ids
    if howto.update(howto_params)
      redirect_to edit_recipe_path(howto.recipe)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    howto = Howto.find(params[:id])
    session[:howtos_ids].delete(howto.id)
    howto.destroy
    redirect_back(fallback_location: root_path)
  end

  private
  def howto_params
    params.require(:howto).permit(:description, :image).merge(recipe_id: params[:recipe_id])
  end

end
