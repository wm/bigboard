class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_github_oauth(request.env["omniauth.auth"])

    if @user && @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Github") if is_navigational_format?
    elsif @user
      session["devise.github_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    else
      orgs = User::ACCEPTABLE_ORGS.keys.join(', ')
      set_flash_message(:notice, :failure, :kind => "Github", :reason => "Not a public member of #{orgs}") if is_navigational_format?
      redirect_to root_url
    end
  end

  def yammer
  end
end
