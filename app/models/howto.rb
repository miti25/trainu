class Howto < ApplicationRecord
  belongs_to :recipe
  has_one_attached :image

  def mini
    image.variant(resize: '100x150').processed
  end
end
