class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook

     # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.present?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      if @user.status != 'closed'
        sign_in_and_redirect @user, :event => :authentication
      else
        flash.discard(:notice)
        flash[:error] = I18n.t 'devise.failure.inactive'
        redirect_to new_user_session_path
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
