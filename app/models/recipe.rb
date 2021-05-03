class Recipe < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 200 }

  belongs_to :user

  scope :recent, -> { order(created_at: :desc) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
