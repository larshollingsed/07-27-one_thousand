class CreateHands < ActiveRecord::Migration
  def change
    create_table :hands do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
