class AddAuthNameAndAuthPasswordToProject < ActiveRecord::Migration[5.2]
  def up
    add_column :projects, :auth_name, :string
    add_column :projects, :auth_password, :string
  end

  def down
    remove_column :projects, :auth_name, :string
    remove_column :projects, :auth_password, :string
  end
end
