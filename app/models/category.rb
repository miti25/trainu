class Category < ApplicationRecord
  validates :name, presence: true
  has_many :recipe_categories
  has_many :recipes, through: :recipe_categories
  has_ancestry
end
