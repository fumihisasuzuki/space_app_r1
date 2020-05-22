class MembersController < EventsController
  before_action :authenticate_user!
  before_action :set_event
  before_action :correct_user
  before_action :set_member, except: %w[create index update_all]
#  before_action :set_members_list, only: %w[index]
  
  def index
#    debugger
    if @decided_schedule
      @members = []
      @decided_schedule.member_schedules.all.each_with_index do |m_s, counter|
        #debugger
        @members << @event.members.find(m_s.member_id) if m_s.attendance_status == params[:status_key]
      end
      @first_number = params[:number_key].to_i
    end
#    debugger
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
    member_schedules_params.each do |id, item|
      if params[:delete_a_member]["#{id}"] == "1"
        member.destroy
      else
        member = Member.find(id)
        member.update_attributes(item)
      end
    end
    flash[:info] = "メンバー情報を更新しました。"
    redirect_to @event
  end
  
  def destroy
    @member.destroy
    flash[:success] = 'このイベントから「' + @member.member_name + '」を削除しました。'
    redirect_to event_url(@event)
  end
  
  private
#  public
  
    # beforeフィルター
  
    # 対象の参加メンバーを取得します。
    def set_member
      if params[:event_id].present? && Event.exists?(params[:event_id])
        @event = Event.find(params[:event_id])
        if params[:id].present? && Member.exists?(params[:id])
          @member = @event.members.find(params[:id])
        else
          debugger
          flash[:danger] = 'id=' + params[:id] + 'のデータは存在しません。'
          redirect_to_home_page_url
        end
      else
        flash[:danger] = 'event_id=' + params[:event_id] + 'のデータは存在しません。'
        redirect_to_home_page_url
      end
    end
    
    # 対象のメンバーリストを取得します。
    def set_members_list
    end
    
    
    # Strong Parameters
      
    # Member#new
    def member_params
      params.require(:member).permit(:member_name,
                                      :comment,
                                      :remark,
                                      :column_number)
    end
  
    # Member#update_all
    def member_schedules_params
      params.require(:event).permit(members: [:member_name,
                                              :comment,
                                              :remark,
                                              member_schedules_attributes: [:id,
                                                                            :attendance_status,
                                                                            :payment_status,
                                                                            :fee]
                                              ])[:members]
    end
    
end