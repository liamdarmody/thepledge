class ChallengesController < ApplicationController
  before_action :logged_in?, :only => [:new, :create, :edit, :update, :destroy]

  def index
    @challenges = Challenge.all
  end

  def my_index
    @challenges = Challenge.where :user_id => @current_user.id
  end

  def create
    # @challenge = Challenge.new challenge_params

    # if @challenge.save
    #   @challenge.update(:user_id => @current_user.id)

    #   m = Mandrill::API.new
    #   message = {  
    #    :subject=> "You've been Challenged to Raise Money for #{@challenge.cause}",  
    #    :from_name=> "#{@current_user.name} at ThePledge.com.au",  
    #    :text=>"Hi #{@challenge.nominee_name}, You've been challenged by #{@current_user.name} to Raise Money for #{@challenge.cause}. Accept the Challenge!",  
    #    :to=>[  
    #      {  
    #        :email=> "#{@challenge.nominee_email}",
    #        :name=> "#{@challenge.nominee_name}"
    #      }  
    #    ],
    #    :html=>"<html><p><strong>Hi #{@challenge.nominee_name},</strong><p>You've been challenged by #{@current_user.name} to Raise Money for #{@challenge.cause}.</p><p><button>Accept the Challenge</button></p></html>",  
    #    :from_email=>"challenges@thepledge.com.au"  
    #   }  
    #   sending = m.messages.send message

    #   redirect_to @challenge
    # else
    #   render :new
    # end



    # @challenge = Challenge.new(challenge_params)
 
    # respond_to do |format|
    #   if @challenge.save

    @challenge = Challenge.new challenge_params

    if @challenge.save
      @challenge.update(:user_id => @current_user.id)    
      Notifier.new_challenge_nominee_email(@challenge).deliver_now
      redirect_to @challenge
    else
      render :new
    end







    # respond_to do |format|
    #   if @challenge.save
    #     ChallengeMailer.new_challenge_nominee_email(@challenge).deliver
    #     format.html { redirect_to @challenge, notice: 'Challenge was successfully created.' }
    #     format.json { render action: 'show', status: :created, location: @challenge }
    #   else
    #     format.html { render action: 'new' }
    #     format.json { render json: @challenge.errors, status: :unprocessable_entity }
    #   end
    # end  




    # respond_to do |format|
    #   if @challenge.save
    #     # Tell the NomineeMailer to send a welcome Email after save
    #     NomineeMailer.new_challenge(@challenge).deliver_now
    #     @challenge.update(:user_id => @current_user.id)
    #   else
    #     render :new
    #   end
    # end

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
    
    unless @challenge.is_owner?(@current_user)
      redirect_to root_path
    end
  end

  def show
    @challenge = Challenge.find params[:id]
  end

  def update
    @challenge = Challenge.find params[:id]
    unless @challenge.is_owner?(@current_user)
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
