class HandsController < ApplicationController
  def show
    @hand = Hand.first
    @dice = Cube.all
  end
end