class AddUtmEAndUtmNToPosition < ActiveRecord::Migration[5.2]
  def up
    add_column :positions, :utm_e, :string
    add_column :positions, :utm_n, :string
  end

  def down
    remove_column :positions, :utm_e, :string
    remove_column :positions, :utm_n, :string
  end
end
