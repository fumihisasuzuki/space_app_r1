class FeesController < EventsController
  before_action :authenticate_user!
  before_action :set_event#, except: %w[new new_a new_b create index]
  before_action :correct_user#, except: %w[new new_a new_b create index]
  
  def edit
  end
  
  def update
    if @event.update_attributes(event_fee_params)
      
#      @total_fee_payed = @decided_schedule.member_schedules.where(attendance_status: "to_attend").group(:payment_status).sum(:fee)
      @fee_numbers = @decided_schedule.member_schedules.where(attendance_status: "to_attend", payment_status: "not_yet").count
      @fee_much_numbers = @decided_schedule.member_schedules.where(attendance_status: "to_attend", payment_status: "not_yet_much").count
      if @fee_numbers > 0 || @fee_much_numbers > 0
        case params[:commit]
          when "会費を指定"
            @event.update_attribute(:calculation_method_type, "fixed")
            @fee = @event.indication_price
            @fee_much = @event.indication_price
          when "割り勘計算"
            @event.update_attribute(:calculation_method_type, "dutch_treat")
            calculate_slope(1)
          when "傾斜で計算"
            @event.update_attribute(:calculation_method_type, "slope")
            calculate_slope(@event.rate_of_fee_slope)
          else
            flash.now[:danger] = "計算に失敗しました。管理者にお問い合わせください。"
            render action: :edit
        end
      end
      @total_fee = @decided_schedule.member_schedules.group(:attendance_status).sum(:fee)
      @total_fee_payed = @decided_schedule.member_schedules.where(attendance_status: "to_attend").group(:payment_status).sum(:fee)
      @the_day_check = true
      @sum = @fee*@fee_numbers + @fee_much*@fee_much_numbers
      flash.now[:success] = @event.event_name + 'の会計計算結果が出ました。採用する場合は「反映」ボタンを押してください。'
      render action: :the_day
    else
      render action: :edit
    end
  end
  
  private
  
    def calculate_slope(rate)
      fee = @event.total_payment / (rate*@fee_much_numbers + @fee_numbers)
      fee_much = rate*fee
      sum_loose = fee.ceil_to(@event.fee_unit)*@fee_numbers + fee_much.floor_to(@event.fee_unit)*@fee_much_numbers
      sum_steep = fee.floor_to(@event.fee_unit)*@fee_numbers + fee_much.ceil_to(@event.fee_unit)*@fee_much_numbers
      if (@event.total_payment.between?(sum_steep, sum_loose) || sum_loose.between?(@event.total_payment, sum_steep)) && fee.ceil_to(@event.fee_unit) <= fee_much.floor_to(@event.fee_unit)
        @fee = fee.ceil_to(@event.fee_unit)
        @fee_much = fee_much.floor_to(@event.fee_unit)
      elsif @event.total_payment.between?(sum_loose, sum_steep) || sum_steep.between?(@event.total_payment, sum_loose)
        @fee = fee.floor_to(@event.fee_unit)
        @fee_much = fee_much.ceil_to(@event.fee_unit)
      else
        @fee = fee.ceil_to(@event.fee_unit)
        @fee_much = fee_much.ceil_to(@event.fee_unit)
      end
    end
  
    # strong parameter
    
    # invitation#update
    def event_fee_params
      params.require(:event).permit(:total_payment, 
                                    :fee_unit,
                                    :rate_of_fee_slope,
                                    :indication_price)
    end
end
