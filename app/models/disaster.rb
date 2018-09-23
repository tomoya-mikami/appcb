class Disaster < ApplicationRecord
  mount_uploader :image, ImageUploader
  has_many :disaster_projects
  has_many :projects, through: :disaster_projects
end
