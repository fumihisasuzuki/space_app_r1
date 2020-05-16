class MembersController < EventsController
  before_action :set_member
  
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
  
  def update_all
    @member.member_schedules.find_by(schedule_id: @decided_schedule.id)
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
