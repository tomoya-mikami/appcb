class Project < ApplicationRecord
  has_secure_token
  has_many :positions, :dependent => :delete_all
  has_many :disaster_projects
  has_many :disasters, through: :disaster_projects
  has_many :sources, :dependent => :delete_all
end
