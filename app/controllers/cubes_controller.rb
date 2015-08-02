class CubesController < ApplicationController
  before_action :set_player
  def keep
    # checks to see if any cubes were submitted(checked)
    if params[:cubes]
      
      # checks round score before adding scores from submitted dice
      starting_score = @player.round
      
      # scores the dice submitted and adds the points to @player.round
      @player.score(params[:cubes][:keep])
      
      # checks to see if the dice were scorable by comparing the round points
      # from before and after the scoring
      if @player.round <= starting_score
        
        # if they weren't scoring, redirects back to same dice roll with notice
        # that there weren't any scores for those dice
        # TODO get notice to show up when submitted non-scoring dice
        @notice = "No score for submitted dice."
        redirect_to hand_path(@player.id)
        
        # if they did score then this updates the player's round points  
      else
        @player.save

        if params[:cubes][:score_and_save]
          redirect_to "/save_score"
        else
        
        # holds dice that were scored
        # sets cubes.held to True (not to be rolled in the next round)
          params[:cubes][:keep].each do |cube_id|
            Cube.find(cube_id).keep
          end
          
          if @player.cubes.where(:held => false).count == 0
            redirect_to "/new_roll"
          
            # if no dice were submitted, redirects back to same roll page  
          else
            redirect_to "/roll_dice"
          end
        end
      end
    end
  end
  
  private
  
  def set_player
    @player = Hand.find(session[:id])
  end
  
end
