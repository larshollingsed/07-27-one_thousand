class Cube < ActiveRecord::Base
  belongs_to :hand
  
  def roll
    this_die = Cube.find(self.id)
    self.face = rand(6) + 1
    self.save
  end
end
