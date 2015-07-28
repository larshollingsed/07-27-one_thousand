class CreateCubes < ActiveRecord::Migration
  def change
    create_table :cubes do |t|
      t.integer :face
      t.integer :hand_id

      t.timestamps null: false
    end
  end
end
