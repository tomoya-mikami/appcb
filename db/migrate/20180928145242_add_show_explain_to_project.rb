class AddShowExplainToProject < ActiveRecord::Migration[5.2]
  def up
    add_column :projects, :show_explain, :string
  end

  def down
    remove_column :projects, :show_explain, :string
  end
end
