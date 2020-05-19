module MembersHelper
  # 参加ステータスの表題を返す
  def status_title(status_key)
    case status_key
    when "to_attend"
      "参加"
    when "on_hold"
      "保留"
    when "to_be_absent"
      "不参加"
    end
  end
end
