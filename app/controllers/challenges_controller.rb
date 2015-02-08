class ChallengesController < ApplicationController
  def index
    @challenges = Challenge.all
  end

  def create
    challenge = Challenge.create challenge_params
    redirect_to challenge
  end

  def new
    @challenge = Challenge.new
  end

  def edit
    @challenge = Challenge.find params[:id]
  end

  def show
    @challenge = Challenge.find params[:id]
  end

  def update
    challenge = Challenge.find params[:id]
    challenge.update challenge_params
    redirect_to challenge
  end

  def destroy
    challenge = Challenge.find params[:id]
    challenge.destroy
    redirect_to challenges_path
  end

  private
  def challenge_params
    params.require(:challenge).permit(:title, :description, :nominee_name, :nominee_email, :banner_image, :cause, :target, :end_date) # Update these with :end_date, :user_id, :published?
  end
end
