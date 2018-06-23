class AddPositionToProjects < ActiveRecord::Migration[5.2]
  def change
    add_reference :projects, :position, foreign_key: true
  end
end
