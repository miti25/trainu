class HowtosController < ApplicationController
  def edit; end

  def create
    howto = Howto.new(howto_params)
    recipe = Recipe.find_by(id: params[:recipe_id])
    howto.recipe_id = params[:recipe_id]
    howto.save
    howto.update(order_num: recipe.howtos.index(howto) + 1)
    redirect_to edit_recipe_path(recipe)
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
    howtos = howto.recipe.howtos.where('order_num > ?', howto.order_num)
    howtos.each do |h|
      h.update(order_num: h.order_num - 1)
    end
    howto.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def howto_params
    params.require(:howto).permit(:description, :image).merge(recipe_id: params[:recipe_id])
  end
end
