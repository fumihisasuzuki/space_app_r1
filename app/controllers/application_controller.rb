class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
    
  # 変数セット
  before_action :set_user
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  
  # beforeフィルター

  # 現在のユーザーを取得します。
  def set_user
#    debugger
    if user_signed_in?
      @user = current_user
      
      if current_user.admin?
        @user_status = "admin-user"
        @home_page_name = 'ユーザーリスト'
        @home_page_path = users_contents_index_path
      else
        @user_status = "logged-in-user"
        @home_page_name = 'ホーム'
        @home_page_path = users_contents_show_path
      end
    else
      @user_status = "guest-user"
      @home_page_name = 'トップ'
      @home_page_path = root_path
    end
#    debugger
    
  end
  
  # それぞれのホーム画面にリダイレクト
  def redirect_to_home_page_url
#    debugger
    if user_signed_in?
      if current_user.admin?
        redirect_to users_contents_index_url
      else
        redirect_to users_contents_show_url
      end
    else
      redirect_to root_url
    end
  end
  
  # 現在ログインしているユーザーが管理者権限を持っているか確認します。
  def admin_user
    unless current_user.admin?
      flash[:danger] = "アクセスするためには管理者権限が必要です。"
      redirect_to_home_page_url
    end
  end
  
  # 現在ログインしているユーザーが一般（管理者でない）か確認します。
  def not_admin_user
    if current_user.admin?
      flash[:success] = "管理者としてログイン中。※管理者にホーム画面はありません。"
      redirect_to_home_page_url
    end
  end

  
  protected

  def configure_permitted_parameters
    added_attrs = [ :email, :user_name, :password, :password_confirmation, :web_search_url, :train_search_url, :map_url, :station, :days_before ]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
  end
  
end
