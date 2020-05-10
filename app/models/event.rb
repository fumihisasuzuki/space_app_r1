class Event < ApplicationRecord
  belongs_to :user
  has_many :members, dependent: :destroy
  has_many :schedules, dependent: :destroy
  
  validates :event_name, presence: true
  validates :chouseisan_note, length: { maximum: 200 }
  validates :reference, length: { maximum: 200 }
  
  # csvインポート処理
  def self.import(file, event)
    # csv_data = CSV.read('member.csv', headers: true)
#    debugger
    if file
      row_num = 0
#      event = find_by(chouseisan_url: url)
      CSV.foreach(file.path, headers: false, encoding: 'Shift_JIS:UTF-8') do |row|
        row_num += 1
#        debugger
        case row_num
        when 1
          event.update_attribute(:event_name, row[0])
        when 2
          event.update_attribute(:chouseisan_note, row[0])
        when 3
          for col in 1..(row.count-1) do
            if row[col]
              member = Member.new
              member.update_attributes(event_id: event.id, column_number: col, member_name: row[col])
              #member.update_attribute(:member_name, row[col])
            end
          end
        else # 4行目以降
          if row[0] != "コメント" && row.count > 1
            schedule = Schedule.new
            schedule.update_attributes(event_id: event.id, held_at: row[0])
            for col in 1..(row.count-1) do
              if row[col]
                member = event.members.find_by(column_number: col)
                member_schedule = MemberSchedule.new
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
          elsif row[0] == "コメント" # 最後の行の処理
            for col in 1..(row.count-1) do
              if row[col]
                member = event.members.find_by(column_number: col)
                member.update_attribute(:comment, row[col])
              end
            end
          
          else
            # ここにはこないはず・・・
          end
        end
        
        # IDが見つかれば、レコードを呼び出し、見つからなければ、新しく作成
        # event = find_by(id: row["id"]) || new
        # CSVからデータを取得し、設定する
        # event.attributes = row.to_hash.slice(*updatable_attributes)
        # 保存する
        # event.save
        
      end
    end
  end

  # csvインポートによる更新を許可するカラムを定義
  def self.updatable_attributes
    #["name", "email", "department", "employee_number", "uid", "basic_work_time", "designated_work_start_time", "designated_work_end_time", "superior", "admin", "password"]
  end
  
end
