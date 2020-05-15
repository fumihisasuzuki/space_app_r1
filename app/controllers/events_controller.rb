class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, except: %w[new new_b create index]
  
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
      
      @schedules = @decided_schedule ? @event.schedules.where(event_id: @event.id, decided: true) : @event.schedules
    end
  end
  
  def edit
  end
  
  def update
    if @event.update_attributes(event_params)
      flash[:success] = @event.event_name + 'を更新しました。'
      redirect_to @event
    else
      render action: :edit
    end
  end
  
  def update_decision_of_schedule
    if params[:schedule_id] && @decided_schedule.blank?
      if @event.schedules.find(params[:schedule_id]).update_attribute(:decided, true)
        flash[:success] = @event.event_name + 'の日程を' + l(@event.schedules.find(params[:schedule_id]).held_at, format: :short)+ 'に決定しました！'
      else
        flash[:danger] = 'なぜか日程の決定に失敗しました。管理者にお問い合わせください。'
      end
    else
      if @decided_schedule.update_attribute(:decided, false)
        flash[:success] = @event.event_name + 'の日程を再考することにしました。'
      else
        flash[:danger] = 'なぜか日程のリセットに失敗しました。管理者にお問い合わせください。'
      end
    end
    redirect_to @event
  end
  
  def update_chouseisan_check
    if @decided_schedule.present? && @event.chouseisan_check?
      if @event.update_attribute(:chouseisan_check, false)
        flash[:success] = @event.event_name + 'を直接編集できます。（今後、調整さんの変更は反映されません。）'
      else
        flash[:danger] = 'なぜか切替に失敗しました。管理者にお問い合わせください。'
      end
    else
      if @event.update_attribute(:chouseisan_check, true)
        flash[:success] = @event.event_name + 'を直接編集できます。（今後、調整さんの変更は反映されません。）'
      else
        flash[:danger] = 'なぜか切替に失敗しました。管理者にお問い合わせください。'
      end
    end
    redirect_to @event
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
        if @decided_schedule = @event.schedules.find_by(event_id: @event.id, decided: true)
          @decided_statuses = @decided_schedule.member_schedules.where(attendance_status: "to_attend").paginate(page: params[:page], per_page: 10)
          @on_hold_statuses = @decided_schedule.member_schedules.where(attendance_status: "on_hold").paginate(page: params[:page], per_page: 10)
        end
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
