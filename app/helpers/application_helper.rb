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
  
  # flashメッセージのタイプを変更。（Deviseでmessageが重複したことにより必要となった）
  def change_flash_message_type(message, before, after)
    if message
      flash.now[after] = message unless message == true
      flash.delete(before)
    end
  end

end
