class AddProjectToPositions < ActiveRecord::Migration[5.2]
  def change
    add_reference :positions, :project, foreign_key: true
  end
end
