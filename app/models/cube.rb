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
end
