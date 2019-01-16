class CreateChains < ActiveRecord::Migration[5.2]
  def change
    create_table :chains do |t|
      t.string :token
      t.string :code
      t.string :amazon_code

      t.timestamps
    end
  end
end
