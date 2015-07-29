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
    @player.save_score
    @player.new_roll
    @player.roll_dice
    redirect_to hand_path(@player.id)
  end
  
  private
  
  def set_player
    @player = Hand.find(session[:id])
  end
  
end