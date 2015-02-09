class PledgesController < ApplicationController
  def new
    @pledge = Pledge.new
  end

  def create
    @pledge = Pledge.new pledge_params
    if @pledge.save
      redirect_to challenge_path
    else
      render :new
    end
  end

  def index
    @pledges = Pledge.all
  end

  private
  def pledge_params
    params.require(:pledge).permit(:amount, :reason)
  end
end
