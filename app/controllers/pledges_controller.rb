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

      
      redirect_to challenge_pledge_pay_path(@challenge, @pledge)
    else
      render :new
    end
  end

  def pay
    @user = @current_user
    @challenge = Challenge.find params[:challenge_id]
    @pledge = Pledge.find params[:pledge_id]
    unless @pledge.is_owner?(@current_user)
      redirect_to root_path
    end
  end

  def charge
    @challenge = Challenge.find params[:challenge_id]
    @pledge = Pledge.find params[:pledge_id]
    # Set your secret key: remember to change this to your live secret key in production
    # See your keys here https://dashboard.stripe.com/account
    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]

    # Get the credit card details submitted by the form
    token = params[:stripeToken]

    charge = Stripe::Charge.create(
      :amount => @pledge.amount * 100, # amount in cents, again
      :currency => "aud",
      :card => token,
      :description => "Pledge #{@pledge.id} for Challenge #{@challenge.id}"
    )
    redirect_to @challenge
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
