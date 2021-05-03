class RecipesController < ApplicationController
  before_action :require_admin_or_himself, only: %i[edit destroy update]
  skip_before_action :login_required, only: %i[show search]

  def index
    @recipes = current_user.recipes.recent
  end

  def show
    @recipe = Recipe.find(params[:id])
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

  def search; end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :description, :image)
  end

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def owned_user?
    recipe = Recipe.find(params[:id])
    user = recipe.user
    current_user&.id == user.id
  end
end
