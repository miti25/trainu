class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    if @recipe.save
      redirect_to @task, notice: 'レシピを登録しました'
    else
      render :new
    end
  end

  def destroy
    recipe = Recipe.find(params[:id])
    recipe.destroy
    redirect_to recipes_url, notice: "#{recipe.name}を削除しました"
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:id])
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
