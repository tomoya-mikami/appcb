class AddEstimateUrlToProject < ActiveRecord::Migration[5.2]
  def up
    add_column :projects, :estimate_url, :string
  end

  def down
    remove_column :projects, :estimate_url, :string
  end
end
