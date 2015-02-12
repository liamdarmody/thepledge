class PledgesController < ApplicationController
  before_action :logged_in?, :only => [:new, :create]

  def new
    @challenge = Challenge.find params[:challenge_id]
    @pledge = Pledge.new
  end

  def create
    
    @challenge = Challenge.find params[:challenge_id]
    @pledge = @challenge.pledges.new pledge_params
    if @pledge.save
      @pledge.update(:user_id => @current_user.id)
      Notifier.new_pledge_nominee_email(@pledge).deliver_now
      redirect_to challenge_path(@challenge)
    else
      render :new
    end
  end

  def index
    @challenge = Challenge.find params[:challenge_id]
    @pledges = Pledge.all
  end

  private
  def pledge_params
    params.require(:pledge).permit(:amount, :reason)
  end
end
