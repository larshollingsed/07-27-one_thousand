class CubesController < ApplicationController
  
  def keep
    params[:cubes][:keep].each do |cube_id|
      Cube.find(cube_id).keep
    end
    redirect_to hand_path(1)
  end
end