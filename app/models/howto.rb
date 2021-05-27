class Howto < ApplicationRecord
  belongs_to :recipe
  has_one_attached :image

  def mini
    image.variant(resize: '120x180').processed
  end
end
