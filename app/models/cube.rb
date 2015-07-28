class Cube < ActiveRecord::Base
  belongs_to :hand
  
  def roll
    self.face = rand(6)
  end
end
