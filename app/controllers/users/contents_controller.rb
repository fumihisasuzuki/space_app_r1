class Users::ContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user, only: %w[index]
  before_action :not_admin_user, only: %w[show]
  
  def index
#    debugger
    @users = User.paginate(page: params[:page], per_page: 10).search(params[:searchword]).where(admin: false).order(:id)
#    debugger
  end

  def show
    @events = current_user.events.all
#    debugger
  end
end
