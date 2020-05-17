module EventsHelper
  # 土日は色をつけるclass
  def css_class_of_the_day(day)
    case $days_of_the_week[day.wday]
    when "土"
      "text-primary"
    when "日"
      "text-danger"
    else
      "text-muted"
    end
  end
  
end
