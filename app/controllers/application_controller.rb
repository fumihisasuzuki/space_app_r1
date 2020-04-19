class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
    
  # 変数セット
  before_action :set_user
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  
  # beforeフィルター

  # 現在のユーザーを取得します。
  def set_user
    if user_signed_in?
      @user_status = "logged-in-user"
      @home_page_path = root_path
      @home_page_name = 'ホーム'
    else
      @user_status = "guest-user"
      @home_page_path = root_path
      @home_page_name = 'ログイン'
    end
    
=begin
    if user_signed_in?
      if params[:user_id].present?
        @user = User.find(params[:user_id])
      elsif params[:id].present?
        @user = User.find(params[:id])
      end
      if current_user.admin?
        @user_status = "admin-user"
        @home_page_path = users_path
        @home_page_name = 'ユーザーリスト'
      else
        @user_status = "logged-in-user"
        @home_page_path = user_path(current_user)
        @home_page_name = 'ホーム'
      end
    else
      @user_status = "guest-user"
      @home_page_path = root_path
      @home_page_name = 'ログイン'
    end
=end
  end
  
end
