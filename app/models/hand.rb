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
    self.cubes.where(:held => false).each do |cube|
      cube.roll
    end
  end
  
  def show_dice
    held_dice = {}
    free_dice = {}
    Cube.all.order(:id).each do |cube|
      if cube.held
        held_dice["die #{cube.id}"] = cube.face
      else
        free_dice["die #{cube.id}"] = cube.face
      end
    end
    dice = {}
    dice[:held] = held_dice
    dice[:free] = free_dice

    dice
  end

end
