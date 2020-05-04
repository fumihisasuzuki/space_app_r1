class EventsController < ApplicationController
  before_action :set_event, only: %w[show]
  
  def new
    @event = Event.new
  end
  
  def new_b
    @event = Event.new
  end
  
  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id
    if @event.save
      flash[:success] = 'イベントを作成しました'
      redirect_to event_path(@event)
    else
      #debugger
      render :new_b
    end
  end
  
  def index
  end

  def show
  end
  
  private
  
    # beforeフィルター
  
    # 対象のイベントを取得します。
    def set_event
      @event = Event.find(params[:id])
    end


    # strong parameter
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

end
