class AddHeldToCubes < ActiveRecord::Migration
  def change
    add_column :cubes, :held, :boolean
    add_column :hands, :total, :integer
    add_column :hands, :round, :integer
  end
end
