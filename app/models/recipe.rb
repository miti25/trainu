class Recipe < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 200 }
  validate :image_type, :image_size
  belongs_to :user
  has_many :howtos, dependent: :destroy
  accepts_nested_attributes_for :howtos, allow_destroy: true
  has_many :recipe_categories, dependent: :destroy
  has_many :categories, through: :recipe_categories
  accepts_nested_attributes_for :recipe_categories, allow_destroy: true
  has_one_attached :image
  scope :recent, -> { order(created_at: :desc) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  def thumbnail
    image.variant(resize: '270x360').processed
  end
end
