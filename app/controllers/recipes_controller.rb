class RecipesController < ApplicationController
  before_action :require_admin_or_himself, only: %i[edit destroy update]
  before_action :set_parents, only: %i[edit new create]
  skip_before_action :login_required, only: %i[show search]

  def index
    @recipes = current_user.recipes.recent
  end

  def show
    @recipe = Recipe.find(params[:id])
    @howtos = @recipe.howtos
    @youngest_categories = @recipe.youngest_categories
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save
      Howto.create(recipe_id: @recipe.id)
      redirect_to edit_recipe_path(@recipe)
    else
      render :new
    end
  end

  def destroy
    set_recipe
    @recipe.destroy
    redirect_to recipes_path, notice: "レシピ「#{@recipe.name}」を削除しました"
  end

  def edit
    set_recipe
    @categories = Category.all
    @category_parents = Category.where(ancestry: nil)
  end

  def update
    set_recipe
    @category_parents = Category.where(ancestry: nil)
    if @recipe.update(recipe_params)
      redirect_to recipe_url, notice: "レシピ「#{@recipe.name}」を更新しました"
    else
      render :edit
    end
  end

  def search
    @q = Recipe.ransack(params[:q])
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :description, :image, { category_ids: [] },
                                    howtos_attributes: %i[description image order_num _destroy id],
                                    recipe_categories_attributes: %i[recipe_id category_id _destroy id])
  end

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def set_parents
    @parents = Category.where(ancestry: nil)
  end

  def owned_user?
    recipe = Recipe.find(params[:id])
    user = recipe.user
    current_user&.id == user.id
  end
end
