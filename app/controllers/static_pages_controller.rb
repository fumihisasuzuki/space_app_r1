class StaticPagesController < ApplicationController
  before_action :guest_user
  
  def top
  end
  
  # beforeフィルター
  
  # ゲストのみ許可（ログインしていたら、ホームへ飛ばす）
  def guest_user
    if user_signed_in?
      if flash.blank?
        flash[:success] = flash.notice ? flash.notice : '既にログイン状態です'
      else
        # flash[:danger]とかの値を入れ直したい。
      end
      redirect_to_home_page_url
    end
  end
  
end
