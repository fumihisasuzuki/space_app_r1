class InvitationsController < EventsController
  before_action :authenticate_user!
  before_action :set_event#, except: %w[new new_a new_b create index]
  before_action :correct_user#, except: %w[new new_a new_b create index]
  
  def edit
  end
  
  def update
    if @event.update_attributes(event_invitation_params)
      flash[:success] = @event.event_name + 'の案内文を更新しました。'
      redirect_to invitations_edit_event_url(@event)
    else
      render action: :edit
    end
  end
  
  
    # strong parameter
    
    # invitation#update
    def event_invitation_params
      params.require(:event).permit(:initial_invitation_statement, 
                                    :schedule_information_statement,
                                    :final_invitation_statement)
    end
end
