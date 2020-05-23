class SchedulesController < EventsController
  before_action :authenticate_user!
  before_action :set_event
  before_action :correct_user
  
end
