class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :google_map_api_key
      t.string :token

      t.timestamps
    end
    add_index :projects, :token, unique: true
  end
end
