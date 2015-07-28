class Hand < ActiveRecord::Base
  has_many :cubes
  
  def new_roll
    Cube.all.order(:id).each do |cube|
      cube.face = nil
      cube.held = false
      self.cubes << cube
    end
  end
    
  def roll_dice
    self.cubes.each do |cube|
      cube.roll
    end
  end
  
  def show_dice
    dice = {}
    Cube.all.order(:id).each do |cube|
      dice["die#{cube.id}"] = cube.face
    end
    dice
  end
  
  def hold_dice(die)
    Cube.find(dice).held = true
  end
end
