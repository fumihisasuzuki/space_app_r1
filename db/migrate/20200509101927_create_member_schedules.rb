class CreateMemberSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :member_schedules do |t|
      t.integer :attendance_status, default:0
      t.integer :payment_status, default:1
      t.integer :fee
      t.references :member, index: true, foreign_key: true
      t.references :schedule, index: true, foreign_key: true

      t.timestamps
    end
  end
end
