class HowtosController < ApplicationController
  def edit; end

  def create
    howto = Howto.new(howto_params)
    howto.recipe_id = params[:recipe_id]
    session[:howtos_ids] = session[:howtos_ids].push(howto.id) if howto.save
    redirect_back(fallback_location: root_path)
  end

  def update
    howto = Howto.find(params[:id])
    recipe = howto.recipe
    if howto.update(howto_params)
      redirect_to edit_recipe_path(recipe)
    else
      flash[:danger] = '保存できません'
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
