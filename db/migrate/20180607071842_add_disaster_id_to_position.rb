class AddDisasterIdToPosition < ActiveRecord::Migration[5.2]
  def up
    add_column :positions, :disaster_id, :integer
  end

  def down
    remove_column :positions, :disaster_id, :integer
  end
end
