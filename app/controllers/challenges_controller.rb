class ChallengesController < ApplicationController
  before_action :logged_in?, :only => [:new, :create, :edit, :update, :destroy]

  def index
    @challenges = Challenge.all
  end

  def my_index
    @challenges = Challenge.where :user_id => @current_user.id
  end

  def create
    @challenge = Challenge.new challenge_params

    if @challenge.save
      @challenge.update(:user_id => @current_user.id)    
      Notifier.new_challenge_nominee_email(@challenge).deliver_now
      redirect_to @challenge
    else
      render :new
    end
    
  end

  def accept
    @challenge = Challenge.find(params[:challenge_id])
    @challenge.update :accepted_date => Time.now
  end

  def new
    @challenge = Challenge.new
  end

  def edit 
    @challenge = Challenge.find params[:id]
    
    unless @challenge.is_owner?(@current_user) || @current_user.is_admin?
      redirect_to root_path
    end
  end

  def show
    @challenge = Challenge.find params[:id]
  end

  def update
    @challenge = Challenge.find params[:id]
    unless @challenge.is_owner?(@current_user) || @current_user.is_admin?
      redirect_to root_path
    end
    
    if @challenge.update challenge_params
      redirect_to @challenge
    else
      render :edit
    end
  end

  def destroy
    challenge = Challenge.find params[:id]
    
    unless @challenge.is_owner?(@current_user)
      redirect_to root_path
    end
    
    challenge.destroy
    redirect_to challenges_path
  end

  private
  def challenge_params
    params.require(:challenge).permit(:title, :description, :nominee_name, :nominee_email, :banner_image, :cause, :target, :end_date) # Update these with :end_date, :user_id, :published?
  end
end
