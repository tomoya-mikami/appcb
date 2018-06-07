class CreateDisasters < ActiveRecord::Migration[5.2]
  def change
    create_table :disasters do |t|
      t.string :disaster_name
      t.string :image

      t.timestamps
    end
  end
end
