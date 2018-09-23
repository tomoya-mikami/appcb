class DisasterProject < ApplicationRecord
  belongs_to :disaster
  belongs_to :project
end
