class Position < ApplicationRecord
  mount_uploader :image, ImageUploader
  validates :longitude, :latitude,presence: true
end
