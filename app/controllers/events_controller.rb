class EventsController < ApplicationController
  before_action :set_event, only: %w[show destroy]
  
  def new
    @event = Event.new
  end
  
  def new_b
    @event = Event.new
  end
  
  def create
#    debugger
    @event = Event.new(event_params)
    @event.user_id = current_user.id
#    debugger
    @schedule = @event.schedules.new(schedules_params)
    
    @event.chouseisan_check =false
    @schedule.decided = true
#    debugger
    if @event.save && @schedule.save
      @schedule.event_id = @event.id
      @schedule.save
      flash[:success] = 'イベントを作成しました'
      redirect_to event_url(@event)
    else
      #debugger
      render :new_b
    end
  end
  
  def index
  end

  def show
    @decided_schedule = @event.schedules.find_by(event_id: @event.id, decided: true)
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
    @event.destroy
    flash[:success] = 'イベント「' + @event.event_name + '」を削除しました。'
    redirect_to users_contents_show_url
  end
  
  private
  
    # beforeフィルター
  
    # 対象のイベントを取得します。
    def set_event
      @event = Event.find(params[:id])
    end


    # strong parameter
    
    # Event#new
    def event_params
      params.require(:event).permit(:event_name,
                                    :chouseisan_note,
                                    :chouseisan_url,
                                    :chouseisan_check,
                                    :place,
                                    :indication_price,
                                    :deadline,
                                    :reserved_at,
                                    :reserved_by,
                                    :reserved_number_of_members,
                                    :reference)
    end
    
    # Schedule#new
    def schedules_params
      params.require(:event).permit(schedules: [:held_at,
                                                :attendance_numbers,
                                                :decided])[:schedules]
    end
end
