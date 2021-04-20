class RecipesController < ApplicationController
  def index
    @recipes = current_user.recipes
  end

  def show
    # @recipe = Recipe.where(user_id: current_user.id) 下記同義
    @recipe = current_user.recipes.find(params[:id])
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save
      redirect_to @task, notice: 'レシピを登録しました'
    else
      render :new
    end
  end

  def destroy
    recipe = current_user.recipes.find(params[:id])
    recipe.destroy
    redirect_to recipes_url, notice: "#{recipe.name}を削除しました"
  end

  def edit
    @recipe = current_user.recipes.find(params[:id])
  end

  def update
    @recipe = current_user.recipes.find(params[:id])
    if @recipe.update(recipe_params)
      redirect_to recipe_url, notice: 'レシピを更新しました'
    else
      render :edit
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :description, :image)
  end
end
