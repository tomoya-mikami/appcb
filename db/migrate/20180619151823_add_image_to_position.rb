class AddImageToPosition < ActiveRecord::Migration[5.2]
  def up
    add_column :positions, :image, :string
  end

  def down
    remove_column :positions, :image, :string
  end
end
