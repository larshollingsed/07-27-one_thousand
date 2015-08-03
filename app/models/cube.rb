class Cube < ActiveRecord::Base
  belongs_to :hand
  
  def roll
    self.face = rand(6) + 1
    self.save
  end
  
  def keep
    self.held = true
    self.save
  end
  
  def face_image
    if face == 1
      "one.png"
    elsif face == 2
      "two.png"
    elsif face == 3
      "three.png"
    elsif face == 4
      "four.png"
    elsif face == 5
      "five.png"
    elsif face == 6
      "six.png"
    end
  end
end
