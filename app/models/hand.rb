class Hand < ActiveRecord::Base
  has_many :cubes
  
  # Resets all cubes to zero and held to false
  # Adds all(6) cubes to Hand(useful later when making this multiplayer)
  def new_roll
    self.save
    Cube.all.order(:id).each do |cube|
      cube.face = nil
      cube.held = false
      self.cubes << cube
    end
    
    # TODO check to see if new roll is unscorable
  end
    
  # rolls all cubes that aren't held
  def roll_dice
    self.cubes.where(:held => false).each do |cube|
      cube.roll
    end
  end
  
  # Sorts dice into :held and :free Hashes then puts in an Array
  # Returns an Array containing two Hashes of Cube objects
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
  
  # Gets the face values of all dice submitted
  # dice is an Array of dice_id's
  # Returns an Array of cube.face (Integers)
  def dice_values(dice)
    values = []
    Cube.find(dice).each do |die|
      values << die.face
    end
    values
  end
  
  # Runs through the different ways to score
  # TODO add self.save here instead of scoring methods!!
  # dice - Array of dice_ids (!!!) to be scored
  def score(dice)
    dice_submitted = self.dice_values(dice)
    if self.straight(dice_submitted)
    elsif three_pairs(dice_submitted)
    else
      self.three_of_kind(dice_submitted)
      self.ones(dice_submitted)
      self.fives(dice_submitted)
    end
  end
  
  # Checks to see if the submitted dice are capable of scoring
  # Returns True if they can score, False if they can't
  def scorable?(dice)
    starting_points = self.round
    score(dice)
    if self.round > starting_points
      self.round = starting_points
      self.save
    end
  end
  
  # Saves round score to total score and resets round score
  # Returns self
  def save_score
    if self.round >= 350
      self.total += self.round
      self.round = 0
      self.save
    # else
    #   return false
    end
  end

  # Scores 1500 if a 1-6 straight is submitted
  # TODO take the 'dice' parameter out of all scoring methods
  def straight(dice)
    if ([1, 2, 3, 4, 5, 6] - dice) == []
      self.round += 1500
      self.save
    end
  end
  
  # gets an organized Array of dice and how many of each was rolled
  # dice is an Array of cube.face Integers
  # Returns a Hash of values and their occurrences in the submitted dice
  def get_by_number(dice)
    dice.each_with_object(Hash.new(0)) { |face,counts| counts[face] += 1 }
  end
  
  
  # scores for three pairs (four of a kind != two pairs)
  def three_pairs(dice)
    if self.get_by_number(dice).values == [2, 2, 2]
      self.round += 750
    end
  end
  
  # scores for 3+ of a kind for 2, 3, 4, 5, and 6 (same scoring scale for multiples)
  def three_of_kind(dice)
    by_number = self.get_by_number(dice)
    for x in [2, 3, 4, 5, 6]
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
  
  #scores for 1s
  def ones(dice)
    ones = self.get_by_number(dice)[1]
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
    self.save
  end
  
  # scores for one or two 5s
  def fives(dice)
    fives = self.get_by_number(dice)[5]
    if fives == 1
      self.round += 50
    elsif fives == 2
      self.round += 100
    end
    self.save
  end
  
end
