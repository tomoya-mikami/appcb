class CreateDisasterProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :disaster_projects do |t|
      t.references :disaster, foreign_key: true
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
