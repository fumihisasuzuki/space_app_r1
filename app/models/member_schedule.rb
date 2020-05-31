class MemberSchedule < ApplicationRecord
  belongs_to :member
  belongs_to :schedule
  enum attendance_status:[:to_be_absent, :on_hold, :to_attend] # 出欠ステータス
  enum payment_status:[:not_need, :not_yet, :not_yet_much, :already_payed] # 支払ステータス
end
