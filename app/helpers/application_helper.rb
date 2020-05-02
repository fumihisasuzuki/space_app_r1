module ApplicationHelper
  # ページごとにタイトルを返す
  def full_title(page_name = "")
    base_title = "SPaCE App"
    if page_name.empty?
      base_title
    else
      page_name + " | " + base_title
    end
  end
  
  def change_flash_message_type(message, before, after)
    if message
      flash.now[after] = message
      flash.delete(before)
#      debugger
    end
  end

end
