class CreateTweets < ActiveRecord::Migration[5.2]
  def change
    create_table :tweets do |t|
      t.integer :tw_id
      t.string :tw_time
      t.string :tw_text
      t.decimal :lon
      t.decimal :lat

      t.timestamps
    end
  end
end
