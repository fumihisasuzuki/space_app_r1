class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, except: %w[new new_a new_b create index]
  before_action :set_only_new_event, only: %w[new new_a new_b]
  before_action :set_only_new_decided_schedule, only: %w[new new_b]
  before_action :set_number_of_members, except: %w[new new_a new_b create]
  #before_action :set_members, only: %w[the_day]
  before_action :correct_user, except: %w[new new_a new_b create index]
  before_action :correct_chouseisan_url, only: %w[show]
  
  def new
  end
  def new_a
  end
  def new_b
  end
  
  def create
    @event = current_user.events.new(event_schedule_params)
    if @event.chouseisan_url
      create_with_chouseisan
    else
      create_without_chouseisan
    end
  end
  
  def index
  end

  def show
    @total_fee = @decided_schedule.member_schedules.group(:attendance_status).sum(:fee) if @decided_schedule
    @the_day_check = false
    if @event.chouseisan_url && @event.chouseisan_check?
      if reg = /=/.match(@event.chouseisan_url)
        chouseisan_uid = reg.post_match
        @export_csv_url = 'https://chouseisan.com/schedule/List/createCsv?h=' + chouseisan_uid
      else
        flash[:danger] = "適切な調整さんURLを登録してください。"
        redirect_to edit_event_path(@event)
      end
    end
  end
  
  def the_day
#      debugger
    first_time_check = @event.event_status
    if @decided_schedule.present? && @event.update_attribute(:event_status, "being_held_now")
      @fee_numbers = @decided_schedule.member_schedules.where(attendance_status: "to_attend", payment_status: "not_yet").count
      @fee_much_numbers = @decided_schedule.member_schedules.where(attendance_status: "to_attend", payment_status: "not_yet_much").count
      @total_fee = @decided_schedule.member_schedules.group(:attendance_status).sum(:fee)
      @total_fee_payed = @decided_schedule.member_schedules.where(attendance_status: "to_attend").group(:payment_status).sum(:fee)
      @total_payment_from_now_on = (@event.total_payment || 0) - (@total_fee_payed["already_payed"] || 0)
      @the_day_check = true
      flash[:success] = @event.event_name + 'を開催しました。（当日モードです。）' unless first_time_check == "being_held_now"
    else
      flash[:danger] = 'なぜか当日モードになりませんでした。管理者にお問い合わせください。'
      redirect_to_home_page_url
    end
  end
  
  def finish
    if @event.update_attribute(:event_status, "finished")
      flash[:success] = @event.event_name + 'が無事終了しました。お疲れさまでした。'
      redirect_to_home_page_url
    else
      flash[:danger] = 'なぜか当日モードになりませんでした。管理者にお問い合わせください。'
      redirect_to the_day_event_path(@event)
    end
  end
  
  def edit
  end
  
  def update
    if @event.update_attributes(event_schedule_params)
      flash[:success] = @event.event_name + 'を更新しました。'
      redirect_to @event
    else
      render action: :edit
    end
  end
  
  def update_decision_of_schedule
    if params[:schedule_id] && @decided_schedule.blank?
      if @event.schedules.find(params[:schedule_id]).update_attribute(:decided, true) && @event.update_attribute(:event_status, "schedule_decided")
        flash[:success] = @event.event_name + 'の日程を' + l(@event.schedules.find(params[:schedule_id]).held_at, format: :short)+ 'に決定しました！'
      else
        flash[:danger] = 'なぜか日程の決定に失敗しました。管理者にお問い合わせください。'
      end
    else
      if @decided_schedule.update_attribute(:decided, false) && @event.update_attribute(:event_status, "pending")
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
        flash[:success] = @event.event_name + 'を「調整さん」で更新できます。'
      else
        flash[:danger] = 'なぜか切替に失敗しました。管理者にお問い合わせください。'
      end
    end
    if params[:new_or_edit_chouseisan_url] == "true"
      flash[:success] = 'STEP１～３にしたがって「' + @event.event_name + '」用の調整さんURLを作成し、登録してください。'
      redirect_to edit_event_path(@event)
    else
      redirect_to @event
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
    Event.import(params[:file], @event)
    if params[:file]
      flash[:success] = "#{:file}をインポートしました。"
    else
      flash[:danger] = "ファイルを選択してください。"
    end
    redirect_to event_url(@event)
  end
  
  private

    # 調整さんで新規イベント作成
    def create_with_chouseisan
      @event.event_name = "（未更新）"
      if @event.save
        flash[:success] = '調整さんURLを登録しました。早速更新してみましょう！'
        redirect_to event_url(@event)
      else
        render :new_a
      end
    end
    
    # 調整さんなしで直接新規イベント作成
    def create_without_chouseisan
      @event.chouseisan_check = false
      @event.event_status = "schedule_decided"
      @event.schedules.first.decided = true
      if @event.save
        @decided_schedule = @event.schedules.first
        @decided_schedule.attendance_numbers.times do |number|
          @member = @event.members.new(member_params)
          @member.member_name = "member#{number + 1}"
          if @member.save
            decided_status = @member.member_schedules.new(schedule_id: @decided_schedule.id, attendance_status: "to_attend")
            unless decided_status.save
              flash[:danger] = 'decided_scheduleモデルの保存時に予期せぬエラーが発生しました。管理者にお問い合わせください。'
              redirect_to event_url(@event) and return
            end
          else
            flash[:danger] = 'システムエラーによりmemberの自動生成に失敗しました。管理者にお問い合わせください。'
            redirect_to event_url(@event) and return
          end
        end
        flash[:danger] = '過去の日付に設定されています。' if @decided_schedule.held_at < Time.current
        flash[:success] = '次は「まとめて編集」で参加者の名前を登録しましょう！'
        redirect_to event_url(@event)
          
      else
        set_only_new_decided_schedule
        render :new_b
      end
    end
    
    
    # beforeフィルター
  
    # 対象のイベントを取得。
    def set_event
#      debugger
      set_id = params[:event_id].blank? ? params[:id] : params[:event_id]
      if Event.exists?(set_id)
        @event = Event.find(set_id)
        if @decided_schedule = @event.schedules.find_by(event_id: @event.id, decided: true)
          @decided_members = @event.members.joins(:member_schedules).where(member_schedules: { attendance_status: "to_attend", schedule_id: @decided_schedule.id }).order(:id).paginate(page: params[:page], per_page: 10)
          @on_hold_members = @event.members.joins(:member_schedules).where(member_schedules: { attendance_status: "on_hold", schedule_id: @decided_schedule.id }).order(:id).paginate(page: params[:page], per_page: 10)
          @to_be_absent_members = @event.members.joins(:member_schedules).where(member_schedules: { attendance_status: "to_be_absent", schedule_id: @decided_schedule.id }).order(:id).paginate(page: params[:page], per_page: 10)
        else
          @event.update_attribute(:event_status, "pending")
        end
        @schedules = @decided_schedule.present? ? @event.schedules.where(event_id: @event.id, decided: true).order(:held_at) : @event.schedules.all
        @decided_shop = @event.shops.find_by(event_id: @event.id, decided: true)
        @shops = @event.shops.all.paginate(page: params[:page], per_page: 10).order(:id)
      else
        flash[:danger] = 'set_event:error; id=' + set_id + 'のデータは存在しません。'
        redirect_to_home_page_url
      end
    end
    
    # new event
    def set_only_new_event
      @event = current_user.events.new
    end
    
    # new decided_schedule
    def set_only_new_decided_schedule
      @decided_schedule = @event.schedules.new(held_at: Time.current.change(hour: 19, min:0, sec: 0))
    end
    
    # 参加人数を取得。
    def set_number_of_members
      if @decided_schedule && @decided_statuses
        @decided_schedule.update_attribute(:attendance_numbers, @decided_statuses.count)
      end
    end
    
    # アクセスしたユーザーが現在ログインしているユーザー本人か確認。
    def correct_user
      unless current_user == User.find(@event.user_id)
        flash[:danger] = "別アカウントの情報にアクセスしようとしています。URLを確認してください。"
        redirect_to_home_page_url
      end
    end
    
    # chouseisan_checkがtrueであるにも関わらず、urlが登録されていない場合は、編集画面へ飛ばす
    def correct_chouseisan_url
      if @event.chouseisan_check? && @event.chouseisan_url.blank?
        flash[:danger] = "適切な調整さんURLを登録してください。"
        redirect_to edit_event_path(@event)
      end
    end
    
    
    # strong parameter
    
    # Event#new
    def event_params
      params.require(:event).permit(:event_name,
                                    :event_status,
                                    :chouseisan_note,
                                    :chouseisan_url,
                                    :chouseisan_check,
                                    :place,
                                    :station,
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
    
    # Member#new
    def member_params
      params.require(:event).permit(members: [:member_name,
                                              :attended,
                                              :comment,
                                              :remark,
                                              :column_number])[:members]
    end
    
    # Event&Schedule#update
    def event_schedule_params
      params.require(:event).permit(:event_name,
                                    :event_status,
                                    :chouseisan_note,
                                    :chouseisan_url,
                                    :chouseisan_check,
                                    :place,
                                    :station,
                                    :indication_price,
                                    :deadline,
                                    :reserved_at,
                                    :reserved_by,
                                    :reserved_number_of_members,
                                    :reference,
                                    schedules_attributes: [:id,
                                                           :held_at,
                                                           :attendance_numbers,
                                                           :decided]
                                    )
    end
    
end
