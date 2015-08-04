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
  
  # Checks to see if the submitted dice are capable of scoring
  # dice is an Array of cube IDS!!!
  # Returns True if they can score, False if they can't
  def scorable?(dice)
    score_dice(dice) > 0
  end
  
  # dice is an Array of cube IDS!!!! (not face values)
  # returns score for those cubes
  def score_dice(dice)
    score(dice_values(dice))
  end
  
  
  # Saves round score to total score and resets round score
  # Returns self
  def save_score
    self.total += self.round
    self.round = 0
    self.save
  end
  
  # gets the score for the submitted dice
  # dice is an Array of face values
  # returns the number of points earned
  def score(dice)
    points = 0
    if straight?(dice)
      1500
    elsif three_pairs?(dice)
      750
    else
      points += three_of_kind2(dice)
      points += ones2(dice)
      points += fives2(dice)
    end
  end
  
  # gets an organized Array of dice and how many of each was rolled
  # dice is an Array of cube.face Integers
  # Returns a Hash of values and their occurrences in the submitted dice
  def get_by_number(dice)
    dice.each_with_object(Hash.new(0)) { |face,counts| counts[face] += 1 }
  end
  
  # checks for a six-dice straight
  # dice is an Array of face values
  # Returns True for a scoring roll or nil for a non-scoring roll
  def straight?(dice)
    ([1, 2, 3, 4, 5, 6] - dice) == []
  end
  
  # checks for three pairs (four of a kind != two pairs)
  # dice is an Array of face values
  # returns True for a scoring roll or nil for a non scoring roll
  def three_pairs?(dice)
    get_by_number(dice).values == [2, 2, 2]
  end
  
  def three_of_kind2(dice)
    points = 0
    by_number = get_by_number(dice)
    for x in [2, 3, 4, 5, 6]
      occurrences = by_number[x]
      if occurrences >= 3
        points += x * 100
        if occurrences >= 4
          points += x * 100
          if occurrences >= 5
            points += x * 200
            if occurrences >= 6
              points += x * 400
            end
          end
        end
      end
    end
    points
  end
  
  def ones2(dice)
    points = 0
    ones = get_by_number(dice)[1]
    if ones == 1
      points += 100
    elsif ones == 2
      points += 200
    elsif ones >= 3
      points += 1000
      if ones >= 4
        points += 1000
        if ones >= 5
          points += 2000
          if ones >= 6 
            points += 4000
          end
        end
      end
    end
    points
  end
  
  # scores for one or two 5s
  # dice is an Array of face values
  # Returns number of points this is worth
  def fives2(dice)
    # this gets the number of fives
    fives = get_by_number(dice)[5]
    points = 0
    if fives == 1
      points = 50
    elsif fives == 2
      points += 100
    end
    points
  end
  
end
