class CreatePositions < ActiveRecord::Migration[5.2]
  def change
    create_table :positions do |t|
      t.integer :position_type
      t.decimal :longitude, :precision => 18, :scale => 15
      t.decimal :latitude, :precision => 18, :scale => 15
      t.string :description

      t.timestamps
    end
  end
end
