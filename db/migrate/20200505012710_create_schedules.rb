class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.datetime :held_at, null: false
      t.boolean :decided
      t.integer :attendance_numbers, null: false, default: 0
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
