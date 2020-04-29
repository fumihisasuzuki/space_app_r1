class Users::ContentsController < ApplicationController
  before_action :authenticate_user!
  
  def index
#    debugger
    @users = User.paginate(page: params[:page], per_page: 10).search(params[:searchword]).where(admin: false).order(:id)
#    debugger
  end

  def show
#    debugger
  end
end
