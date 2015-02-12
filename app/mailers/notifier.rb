class Notifier < ApplicationMailer
  default from: 'hello@thepledge.com.au',
          return_path: 'hello@thepledge.com.au'

  def new_challenge_nominee_email(challenge)
    @challenge = challenge
    mail(to: challenge.nominee_email)
  end

  def new_pledge_nominee_email(pledge)
    @pledge = pledge
    mail(to: pledge.challenge.nominee_email)
  end
end