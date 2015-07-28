class HandsController < ApplicationController
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
end