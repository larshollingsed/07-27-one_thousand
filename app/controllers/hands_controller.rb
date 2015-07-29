class HandsController < ApplicationController
  before_action :set_player, except: [:new_game, :index]
  
  def new_game
    @player1 = Hand.find(1)
    @player1.name = params[:hand][:p1]
    @player1.total = 0
    @player1.round = 0
    @player2 = Hand.find(2)
    @player2.name = params[:hand][:p2]
    @player2.total = 0
    @player2.round = 0
    
    @player1.save
    @player2.save
    session[:id] = 1
    redirect_to hand_path(@player1.id)
  end
  
  def show
    @hand = @player
    @dice = Cube.all
    @hands = Hand.all
  end
  
  def roll_dice
    @player.roll_dice
    redirect_to hand_path(@player.id)
  end
  
  def new_roll
    @player.new_roll
    @player.roll_dice
    redirect_to hand_path(@player.id)
  end
  
  def save_score
    # adds round score to total(permanent) score and sets round score to 0
    @player.save_score
    
    # changes players and sets new @player
    change_player
    
    # resets all cubes and adds them to player
    @player.new_roll
    
    # rolls non-held dice (which is all of them)
    @player.roll_dice
    
    # redirects to show 
    redirect_to hand_path(@player.id)
  end
  
  private
  
  def set_player
    @player = Hand.find(session[:id])
  end
  
  def change_player
    if session[:id] == 1
      session[:id] = 2
    elsif session[:id] == 2
      session[:id] = 1
    end
    set_player
  end
  
end