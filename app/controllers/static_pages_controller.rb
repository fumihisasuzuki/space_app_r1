class StaticPagesController < ApplicationController
  before_action :guest_user
  
  def top
  end
  
  # beforeフィルター
  
  # ゲストのみ許可（ログインしていたら、ホームへ飛ばす）
  def guest_user
    if user_signed_in?
      flash[:success] = flash.notice ? flash.notice : '既にログイン状態です'
      redirect_to_home_page_url
    end
  end
  
end
