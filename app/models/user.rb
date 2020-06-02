class User < ApplicationRecord
  has_many :events, dependent: :destroy
  devise :database_authenticatable,
         :registerable,
         :recoverable, 
         :rememberable, 
         :validatable,
         #:confirmable, 
         :lockable, 
         :timeoutable, 
         :trackable,
         :omniauthable, omniauth_providers: [:line]
         
  
  # ユーザー検索機能。
  def User.search(search)
    return User.all unless search
    User.where(['name LIKE ?', "%#{search}%"])
  end
  
  # SNSログインに必要。 
#  has_many :social_profiles, dependent: :destroy
  def social_profile(provider)
    social_profiles.select{ |sp| sp.provider == provider.to_s }.first
  end
  
  def set_values(omniauth)
    return if provider.to_s != omniauth['provider'].to_s || uid != omniauth['uid']
    credentials = omniauth['credentials']
    info = omniauth['info']
  
    access_token = credentials['refresh_token']
    access_secret = credentials['secret']
    credentials = credentials.to_json
    name = info['name']
    # self.set_values_by_raw_info(omniauth['extra']['raw_info'])
  end

  def set_values_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    self.save!
  end
  
  # passwordを更新しない場合は、current_passwordなしで更新
  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end
  
end
