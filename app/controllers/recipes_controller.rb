class RecipesController < ApplicationController
  def index
    @recipes = current_user.recipes.recent
  end

  def show
    set_recipe
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save
      redirect_to @recipe, notice: "レシピ「#{@recipe.name}」を登録しました"
    else
      render :new
    end
  end

  def destroy
    set_recipe
    @recipe.destroy
    redirect_to recipes_url, notice: "レシピ「#{@recipe.name}」を削除しました"
  end

  def edit
    set_recipe
  end

  def update
    set_recipe
    if @recipe.update(recipe_params)
      redirect_to recipe_url, notice: "レシピ「#{@recipe.name}」を更新しました"
    else
      render :edit
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :description, :image)
  end

  def set_recipe
    # @recipe = Recipe.where(user_id: current_user.id) 下記同義
    @recipe = current_user.recipes.find(params[:id])
  end
end
