class RenameDisasterNameColumnToDisasters < ActiveRecord::Migration[5.2]
  def up
    rename_column :disasters, :disaster_name, :name
  end

  def down
    rename_column :disasters, :name, :disaster_name
  end
end
