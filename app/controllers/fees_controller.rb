class FeesController < EventsController
  before_action :authenticate_user!
  before_action :set_event#, except: %w[new new_a new_b create index]
  before_action :correct_user#, except: %w[new new_a new_b create index]
  
  def edit
  end
  
  def create
    if event_fee_params[:total_payment].present?
      if @event.update_attributes(event_fee_params)
        @fee_numbers = @decided_schedule.member_schedules.where(attendance_status: "to_attend", payment_status: "not_yet").count
        @fee_much_numbers = @decided_schedule.member_schedules.where(attendance_status: "to_attend", payment_status: "not_yet_much").count
        @total_fee = @decided_schedule.member_schedules.group(:attendance_status).sum(:fee)
        @total_fee_payed = @decided_schedule.member_schedules.where(attendance_status: "to_attend").group(:payment_status).sum(:fee)
        @the_day_check = true
        if @fee_numbers > 0 || @fee_much_numbers > 0
          case params[:commit]
            when "会費を指定"
              @event.update_attribute(:calculation_method_type, "fixed")
              @fee = @event.indication_price || 0
              @fee_much = @event.indication_price || 0
              flash.now[:danger] = '「会費を指定」するには、予想会費を入力してください。' if @event.indication_price.blank?
            when "割り勘計算"
              @event.update_attribute(:calculation_method_type, "dutch_treat")
              calculate_slope(1)
            when "傾斜で計算"
              @event.update_attribute(:calculation_method_type, "slope")
              calculate_slope(@event.rate_of_fee_slope || 1)
              flash.now[:danger] = '「傾斜で計算」するには、傾斜率を入力してください。' if @event.rate_of_fee_slope.blank?
            else
              flash.now[:danger] = "計算に失敗しました。管理者にお問い合わせください。"
              render action: :edit
          end
        end
        @sum = @fee*@fee_numbers + @fee_much*@fee_much_numbers
        flash.now[:success] = @event.event_name + 'の会計計算結果が出ました。採用する場合は「計算結果を反映」ボタンを押してください。'
        render action: :the_day
      else
        render action: :edit
      end
    else
      flash[:danger] = '支払総額を入力してください。'
      redirect_to the_day_event_path(@event)
    end
  end
  
  def update
    if params[:fee].present? && params[:fee_much].present?
      @fee_members = @decided_schedule.member_schedules.where(attendance_status: "to_attend", payment_status: "not_yet")
      @fee_members.each do |m_s|
        m_s.update_attribute(:fee, params[:fee])
      end
      @fee_much_members = @decided_schedule.member_schedules.where(attendance_status: "to_attend", payment_status: "not_yet_much")
      @fee_much_members.each do |m_s|
        m_s.update_attribute(:fee, params[:fee_much])
      end
      flash[:success] = @event.event_name + 'の会計計算結果を反映しました。'
      redirect_to the_day_event_path(@event)
    else
      flash.now[:danger] = "反映に失敗しました。管理者にお問い合わせください。"
      render action: :the_day
    end
  end
    
  
  private
  
    def calculate_slope(rate)
      @total_payment_from_now_on = @event.total_payment - (@total_fee_payed["already_payed"] || 0)
      unit = @event.fee_unit || 1
      fee = @total_payment_from_now_on / (rate*@fee_much_numbers + @fee_numbers)
      fee_much = rate*fee
      sum_loose = fee.ceil_to(unit)*@fee_numbers + fee_much.floor_to(unit)*@fee_much_numbers
      sum_steep = fee.floor_to(unit)*@fee_numbers + fee_much.ceil_to(unit)*@fee_much_numbers
      if (@total_payment_from_now_on.between?(sum_steep, sum_loose) || sum_loose.between?(@total_payment_from_now_on, sum_steep)) && (fee.ceil_to(unit) <= fee_much.floor_to(unit))
        @fee = fee.ceil_to(unit)
        @fee_much = fee_much.floor_to(unit)
      elsif @total_payment_from_now_on.between?(sum_loose, sum_steep) || sum_steep.between?(@total_payment_from_now_on, sum_loose)
        @fee = fee.floor_to(unit)
        @fee_much = fee_much.ceil_to(unit)
      else
        @fee = fee.ceil_to(unit)
        @fee_much = fee_much.ceil_to(unit)
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
