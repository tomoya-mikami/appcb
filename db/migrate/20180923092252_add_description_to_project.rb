class AddDescriptionToProject < ActiveRecord::Migration[5.2]
  def up
    add_column :projects, :description, :string
  end

  def down
    remove_column :projects, :description, :string
  end
end
