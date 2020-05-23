class Event < ApplicationRecord
  belongs_to :user
  has_many :members, dependent: :destroy
  has_many :schedules, dependent: :destroy
  
  VALID_URL_REGEX = /(\A\z)|(\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\z)/ix
#  VALID_CHOUSEISAN_URL_REGEX = /(\A\z)|(\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?+=[a-z0-9]\z)/ix
  validates :event_name, presence: true
  validates :chouseisan_url, presence: true, length: { maximum: 200 }, format: { with: VALID_URL_REGEX }, if: :create_with_chouseisan?
  validates :chouseisan_note, length: { maximum: 200 }
  validates :reference, length: { maximum: 200 }
  
  # csvインポート処理
  def self.import(file, event)
    if file
      row_num = 0
      CSV.foreach(file.path, headers: false, encoding: 'Shift_JIS:UTF-8') do |row|
        row_num += 1
#        debugger
        case row_num
        when 1 # 1行目の処理（イベント名）
          event.update_attribute(:event_name, row[0])
        when 2 # 2行目の処理（イベント説明）
          event.update_attribute(:chouseisan_note, row[0])
        when 3 # 3行目の処理（表ヘッダー）
          for col in 1..(row.count-1) do
            if row[col]
              member = event.members.find_by(event_id: event.id, column_number: col) || event.members.new
              member.update_attributes(event_id: event.id, column_number: col, member_name: row[col])
            end
          end
        else # 4行目以降の処理（表の中身）
          unless row[0] == "コメント" # 4行目以降（最後の行は除く）の処理
            schedule = event.schedules.find_by(event_id: event.id, held_at: Time.zone.parse(row[0])) || event.schedules.new
            schedule.update_attributes(event_id: event.id, held_at: Time.zone.parse(row[0]))
            if row.count > 1
              for col in 1..(row.count-1) do
                if row[col]
                  member = event.members.find_by(column_number: col)
                  member_schedule = member.member_schedules.find_by(schedule_id: schedule.id) || member.member_schedules.new
                  case row[col]
                  when "○"
                    status = "to_attend"
                  when "△"
                    status = "on_hold"
                  when "×"
                    status = "to_be_absent"
                  end
                  member_schedule.update_attributes(member_id: member.id, schedule_id: schedule.id, attendance_status: status)
                end
              end
            end
            schedule.update_attribute(:attendance_numbers, schedule.member_schedules.where(attendance_status: "to_attend").count)
          else # 最後の行の処理
            if row.count > 1
              for col in 1..(row.count-1) do
                if row[col]
                  member = event.members.find_by(column_number: col)
                  member.update_attribute(:comment, row[col])
                end
              end
            end
          end
        end
      end
    end
  end


  private
    # 調整さんでnewするときのみバリデーション
    def create_with_chouseisan?
      chouseisan_url.present?
    end
    
end
