class Hand < ActiveRecord::Base
  has_many :cubes
  
  def new_roll
    self.round = 0
    self.save
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
  
  def roll_and_show
    self.roll_dice
    self.dice_values
  end
  
  def dice_values
    self.show_dice[:free].values
  end
  
  def score
    dice = self.dice_values
    self.straight(dice)
    self.three_of_kind(dice)
  end
  
  def save_score
    self.total += self.round
    self.save
  end

  def straight(dice)
    if ([1, 2, 3, 4, 5, 6] - dice) == []
      self.round += 1500
      self.save
    end
  end
  
  def three_of_kind(dice)
    by_number = dice.each_with_object(Hash.new(0)) { |face,counts| counts[face] += 1 }
    for x in 2..6
      occurrences = by_number[x]
      if occurrences >= 3
        self.round += x * 100
        if occurrences >= 4
          self.round += x * 100
          if occurrences >= 5
            self.round += x * 200
            if occurrences >= 6
              self.round += x * 400
            end
          end
        end
      end
    end
  end
  
  def ones(dice)
    ones = by_number[1]
    if ones == 1
      self.round += 100
    elsif ones == 2
      self.round += 200
    elsif ones >= 3
      self.round += 1000
      if ones >= 4
        self.round += 1000
        if ones >= 5
          self.round += 2000
          if ones >= 6 
            self.round += 4000
          end
        end
      end
    end
    binding.pry
    self.save
  end
end
