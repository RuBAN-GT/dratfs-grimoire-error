class Web::Devise::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Web::ApplicationControllerConcern

  def bungie
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      @user.remember_me = true

      sign_in_and_redirect @user, :event => :authentication

      set_flash_message(:notice, :success, :kind => 'Bungie') if is_navigational_format?
    else
      session["devise.bungie_data"] = request.env["omniauth.auth"]

      redirect_to '/'
    end
  end

  def failure
    redirect_to '/'
  end
end
