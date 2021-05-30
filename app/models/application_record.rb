class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def image_type
    return if !image.attached? || image.blob.content_type.in?(%('image/jpeg image/png'))

    image.purge
    errors.add(:image, 'はjpegまたはpng形式でアップロードしてください')
  end

  def image_size
    return if !image.attached? || image.blob.byte_size < 5.megabytes

    image.purge
    errors.add(:image, 'は1つのファイル5MB以内にしてください')
  end
end
