module ApplicationHelper
  def nav_menu
    links = "<li>#{ link_to('ThePledge.com.au', root_path) }</li>"
    links += "<li>#{ link_to('Start a Challenge', new_challenge_path) }</li>"
    links += "<li>#{ link_to('Browse', challenges_path) }</li>"

    if @current_user.present?

      if @current_user.is_admin?
        links += "<li>#{ link_to('All Users', users_path) }</li>"
      end

      links += "<li>#{ link_to('My Challenges', my_challenges_path) }</li>"
      links += "<li>#{ link_to('My Profile', user_path(@current_user.id)) }</li>"
      links += "<li>#{ link_to('Sign Out ' + @current_user.name, login_path, :method => :delete) }</li>"
    else
      links += "<li>#{ link_to('Sign Up', new_user_path) }</li><li>#{ link_to('Log In', login_path) }</li>"
    end

    links
  end  
end