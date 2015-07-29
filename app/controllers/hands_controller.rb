class HandsController < ApplicationController
  
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
    redirect to hand_path(@player1.id)
  end
  
  def show
    @hand = Hand.first
    @dice = Cube.all
  end
  
  def roll_dice
    Hand.first.roll_dice
    redirect_to hand_path(1)
  end
  
  def new_roll
    Hand.first.new_roll
    Hand.first.roll_dice
    redirect_to hand_path(1)
  end
  
  def save_score
    Hand.first.save_score
    Hand.first.new_roll
    Hand.first.roll_dice
    redirect_to hand_path(1)
  end
  
  private
  
  def get_player
    
  end
  
end