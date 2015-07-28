class CubesController < ApplicationController
  
  def keep
    @player = Hand.first
    if params[:cubes]
        
      #TODO make sure a submitted round of dice is scorable!!
      @player.score
      params[:cubes][:keep].each do |cube_id|
        Cube.find(cube_id).keep
      end
    end
    if @player.cubes.where(:held => false).count == 0
      redirect_to "/new_roll"
    else
      redirect_to hand_path(1)
    end
  end
end
