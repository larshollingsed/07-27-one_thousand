class Hand < ActiveRecord::Base
  has_many :cubes
  
  def roll_hand
    self.cubes.each do |cube|
      cube.roll
    end
  end
end
