class CubesController < ApplicationController
  before_action :set_player
  
  def keep
    # checks to see if any cubes were submitted(checked)
    if params[:cubes]
      dice = params[:cubes][:keep]
      if @player.scorable?(dice)
        @player.round += @player.score_dice(dice)
        @player.save
      else
        redirect_to hand_path(@player.id)
      end
      
      if params[:cubes][:score_and_save] && @player.round >= 350
        redirect_to "/save_score"
      else
        params[:cubes][:keep].each do |cube_id|
          Cube.find(cube_id).keep
        end
        if @player.cubes.where(:held => false).count == 0
          redirect_to "/new_roll"
        
          # if free dice are still left, rolls those
        else
          redirect_to "/roll_dice"
        end
      end
    else
      redirect_to hand_path(@player.id)
    end
  end
      
  private
  
  def set_player
    @player = Hand.find(session[:id])
  end
  
end
