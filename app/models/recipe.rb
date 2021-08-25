class Recipe < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 200 }
  validate :image_type, :image_size
  belongs_to :user
  has_many :recipe_categories, dependent: :destroy
  has_many :categories, through: :recipe_categories
  accepts_nested_attributes_for :recipe_categories, allow_destroy: true
  has_many :howtos, dependent: :destroy
  accepts_nested_attributes_for :howtos, allow_destroy: true
  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user
  has_one_attached :image
  scope :recent, -> { order(created_at: :desc) }

  def youngest_categories
    categories = self.categories.uniq
    categories.each do |category|
      next unless category.ancestors?

      categories.delete_if do |str|
        category.ancestors.include?(str)
      end
    end
  end

  def root_categories
    categories = self.categories.uniq
    categories.each do |category|
      next unless category.root?

      categories.delete_if do |str|
        category.descendants.include?(str)
      end
    end
  end

  def self.ransackable_scopes(_auth_object = nil)
    %i[name_or_description_or_categories_name_cont_any]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[name description]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[categories]
  end

  def thumbnail
    image.variant(resize: '300x400').processed
  end

  def mini
    image.variant(resize: '240x320').processed
  end
end
