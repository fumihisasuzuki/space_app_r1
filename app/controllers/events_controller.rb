class EventsController < ApplicationController
  before_action :set_event, only: %w[show destroy import]
  
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
    
    if @event.chouseisan_url
      @event.event_name = "調整さんで更新してみましょう！"
      if @event.save
        flash[:success] = '調整さんURLを登録しました。早速更新してみましょう！'
        redirect_to event_url(@event)
      else
        render :new_b
      end
      
    else
      @event.chouseisan_check =false
      @schedule = @event.schedules.new(schedules_params)
      @schedule.decided = true
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
  end
  
  def index
  end

  def show
    @decided_schedule = @event.schedules.find_by(event_id: @event.id, decided: true)
    if @event.chouseisan_check
      reg = /=/.match(@event.chouseisan_url)
      chouseisan_uid = reg.post_match
      
      @export_csv_url = 'https://chouseisan.com/schedule/List/createCsv?h=' + chouseisan_uid
      
      # redirect_to export_csv_url
    end
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
  
  
  def import
    # fileはtmpに自動で一時保存される
#    debugger
    Event.import(params[:file], @event)
    if params[:file]
      flash[:success] = "#{:file}をインポートしました。"
    else
      flash[:danger] = "ファイルを選択してください。"
    end
#    debugger
    redirect_to event_url(@event)
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
