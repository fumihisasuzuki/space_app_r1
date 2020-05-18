class MembersController < EventsController
  before_action :authenticate_user!
  before_action :set_event
  before_action :correct_user
  before_action :set_member, except: %w[create index]
  
  def index
    if @decided_schedule
      @members_to_attend = []
      @members_on_hold = []
      @members_to_be_absent = []
      @decided_schedule.member_schedules.all.each_with_index do |m_s, counter|
        #debugger
        case m_s.attendance_status
        when "to_attend"
          @members_to_attend << @event.members.find(m_s.member_id)
        when "on_hold"
          @members_on_hold << @event.members.find(m_s.member_id)
        when "to_be_absent"
          @members_to_be_absent << @event.members.find(m_s.member_id)
        end
      end
#      @members_to_attend = @members_to_attend.paginate(page: params[:page], per_page: 10)
#      @members_on_hold = @members_on_hold.paginate(page: params[:page], per_page: 10)
#      @members_to_be_absent = @members_to_be_absent.paginate(page: params[:page], per_page: 10)
    end
  end
  
  def create
    @member = @event.members.new(member_params)
    if @member.save
      @decided_status = @member.member_schedules.new(attendance_status: params[:status_key], schedule_id: @decided_schedule.id)
      if @decided_status.save
        flash[:success] = 'メンバー「' + @member.member_name + '」を追加しました。'
        redirect_to event_url(@event)
      else
        debugger
        flash[:danger] = 'なぜか参加者の追加に失敗しました。管理者にお問い合わせください。'
        redirect_to event_url(@event)
      end
    else
      debugger
      flash[:danger] = 'なぜか参加者の追加に失敗しました。管理者にお問い合わせください。'
      redirect_to event_url(@event)
    end
  end
  
  def edit
  end
  
  def update
    #debugger
    if @member.update_attributes(member_params)
      flash[:success] = @member.member_name + 'を更新しました。'
      redirect_to @event
    else
      render action: :edit
    end
  end
  
  def update_status
    #debugger
    member_status = @member.member_schedules.find(params[:attendance_id])
    if member_status.update_attribute(:attendance_status, params[:key].to_i)
      if @decided_schedule.update_attribute(:attendance_numbers, @decided_schedule.member_schedules.where(attendance_status: "to_attend").count)
        flash[:success] = @member.member_name + 'を' + member_status.attendance_status_i18n + 'に変更しました。'
        redirect_to @event
      else
      render action: :edit
      end
    else
      #debugger
      render action: :edit
    end
  end
    
  
  def update_all
    @member.member_schedules.find_by(schedule_id: @decided_schedule.id)
  end
  
  def destroy
    @member.destroy
    flash[:success] = 'このイベントから「' + @member.member_name + '」を削除しました。'
    redirect_to event_url(@event)
  end
  
  private
#  public
  
    # beforeフィルター
  
    # 対象のイベントを取得します。
    def set_member
      if params[:event_id].present? && Event.exists?(params[:event_id])
        @event = Event.find(params[:event_id])
        if params[:id].present? && Member.exists?(params[:id])
          @member = @event.members.find(params[:id])
        else
          flash[:danger] = 'id=' + params[:id] + 'のデータは存在しません。'
          redirect_to_home_page_url
        end
      else
        flash[:danger] = 'event_id=' + params[:event_id] + 'のデータは存在しません。'
        redirect_to_home_page_url
      end
    end
    
    # Member#new
    def member_params
      params.require(:member).permit(:member_name,
                                              :comment,
                                              :remark,
                                              :column_number)
    end
    
end
