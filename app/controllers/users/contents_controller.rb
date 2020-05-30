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
    start_time = Time.parse("1900/1/1 1") # Excelに見習って、登録は1900年～
    @past_time = Time.current - 60*60*12
    @future_time = (Time.current + 60*60*24*current_user.days_before).end_of_day
    finish_time = Time.current + 60*60*24*365*10 # 10年後まで登録可能。
    @events_past = current_user.events.joins(:schedules).where(schedules: { decided: true}).where(schedules: { held_at: start_time...@past_time }).order("schedules.held_at ASC")
    @events_soon = current_user.events.joins(:schedules).where(schedules: { decided: true}).where(schedules: { held_at: @past_time..@future_time }).order("schedules.held_at ASC")
    @events_after_a_few_days = current_user.events.joins(:schedules).where(schedules: { decided: true}).where(schedules: { held_at: @future_time...finish_time }).order("schedules.held_at ASC")
    @events_pending = current_user.events.where(event_status: "pending")
#    debugger
  end
end
