class Recipe < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 200 }

  belongs_to :user

  scope :recent, -> { order(created_at: :desc) }
end