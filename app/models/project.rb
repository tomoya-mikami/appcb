class Project < ApplicationRecord
  has_secure_token
  has_many :positions, :dependent => :delete_all
end
