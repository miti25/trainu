class RecipesController < ApplicationController
  before_action :require_admin_or_himself, only: %i[edit destroy update]
  before_action :set_parents, only: %i[edit new create]
  skip_before_action :login_required, only: %i[show search]

  def index
    @recipes = current_user.recipes.includes([:recipe_categories, :categories]).with_attached_image.recent
  end

  def show
    set_recipe
    @howtos = @recipe.howtos.with_attached_image
    @root_categories = @recipe.root_categories
    @favorite = Favorite.new
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

  def edit
    set_recipe
    @howtos = @recipe.howtos.with_attached_image
    @categories = Category.all
    @root_categories = Category.where(ancestry: nil)
  end

  def update
    set_recipe
    @recipe.categories.distinct
    @root_categories = Category.where(ancestry: nil)
    if @recipe.update(recipe_params)
      @recipe.categories.each do |category|
        @recipe.category_ids = @recipe.category_ids | category.ancestor_ids
      end
      redirect_to recipe_url, notice: "レシピ「#{@recipe.name}」を更新しました"
    else
      render :edit
    end
  end

  def destroy
    set_recipe
    @recipe.destroy
    redirect_to recipes_path, notice: "レシピ「#{@recipe.name}」を削除しました"
  end

  def image_destroy
    set_recipe
    if @recipe.image.attached?
      @recipe.image.purge
      redirect_to edit_recipe_path(@recipe)
    else
      render :edit
    end
  end

  def search
    @q = Recipe.([:user, :recipe_categories, :categories]).with_attached_image.ransack(params[:q])
  end

  def category
    @category = Category.find(params[:format])
    @recipes = @category.recipes.includes([:user, :recipe_categories, :categories]).with_attached_image
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
