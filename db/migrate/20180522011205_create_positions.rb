class CreatePositions < ActiveRecord::Migration[5.2]
  def change
    create_table :positions do |t|
      t.integer :type
      t.decimal :longitude
      t.decimal :latitude
      t.string :description

      t.timestamps
    end
  end
end
