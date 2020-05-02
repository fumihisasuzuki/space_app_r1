# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line; basic_action end

  private

  def basic_action
    @omniauth = request.env['omniauth.auth']
    if @omniauth.present?
      @profile = User.where(provider: @omniauth['provider'], uid: @omniauth['uid']).first
      if @profile
        @profile.set_values(@omniauth)
        sign_in(:user, @profile)
      else
        @profile = User.new(provider: @omniauth['provider'], uid: @omniauth['uid'])
        email = @omniauth['info']['email'] ? @omniauth['info']['email'] : "#{@omniauth['uid']}-#{@omniauth['provider']}@example.com"
        @profile = current_user || User.create!(provider: @omniauth['provider'], uid: @omniauth['uid'], email: email, user_name: @omniauth['info']['name'], password: Devise.friendly_token[0, 20])
        @profile.set_values(@omniauth)
        sign_in(:user, @profile)
        # redirect_to edit_user_path(@profile.user.id) and return
      end
    end
    # debugger
    if current_user.email == "#{@omniauth['uid'].downcase}-#{@omniauth['provider']}@example.com"
      flash[:info] = "万が一の際の連絡先として、ぜひ、メールアドレスを登録ください！"
    else
      flash[:success] = "LINEでログインしました。"
    end
    redirect_to edit_user_registration_path
  end

  def fake_email(uid,provider)
    return "#{auth.uid}-#{auth.provider}@example.com"
  end

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
  
  
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]
  
  # More info at:
  # https://github.com/plataformatec/devise#omniauth

end
