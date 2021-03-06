class Howto < ApplicationRecord
  validates :description, length: { maximum: 100 }, presence: true
  validate :image_type, :image_size
  belongs_to :recipe
  has_one_attached :image

  def mini
    image.variant(resize: '240x320').processed
  end
end
