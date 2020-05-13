class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %w[edit show update destroy destroy_members_and_schedules import]
  
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
      @event.event_name = "（未更新）"
      if @event.save
        flash[:success] = '調整さんURLを登録しました。早速更新してみましょう！'
        redirect_to event_url(@event)
      else
        render :new_b
      end
      
    else
      @event.chouseisan_check =false
      @schedule = @event.schedules.new(schedule_params)
      @schedule.decided = true
      if @event.save && @schedule.save
        @schedule.event_id = @event.id
        @schedule.save
        flash[:success] = '次は参加者の名前を登録しましょう！'
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
#    debugger
    if @event.update_attributes(event_params)
      flash[:success] = @event.event_name + 'を更新しました。'
      redirect_to @event
    else
      render action: :edit
    end
  end
  
  def destroy
    @event.destroy
    flash[:success] = 'イベント「' + @event.event_name + '」を削除しました。'
    redirect_to users_contents_show_url
  end
  
  def destroy_members_and_schedules
    if Member.where(event_id: @event.id).destroy_all && Schedule.where(event_id: @event.id).destroy_all
      flash[:success] = '参加者と日程を全て削除しました。'
      redirect_to event_url(@event)
    else
      flash[:danger] = 'なぜか参加者と日程の削除に失敗しました。'
      render action: :show
    end
  end
  
  # csvインポート（引数に@eventが必要）
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
      if Event.exists?(params[:id])
        @event = Event.find(params[:id])
        @decided_schedule = @event.schedules.find_by(event_id: @event.id, decided: true)
      else
        flash[:danger] = 'id=' + params[:id] + 'のデータは存在しません。'
        redirect_to_home_page_url
      end
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
    def schedule_params
      params.require(:event).permit(schedules: [:held_at,
                                                :attendance_numbers,
                                                :decided])[:schedules]
    end
end
