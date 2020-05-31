class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :event_name, null: false, default: ""
      t.string :chouseisan_note
      t.string :chouseisan_url
      t.boolean :chouseisan_check, null: false, default: true
      t.string :place, default: ""
      t.integer :indication_price
      t.date :deadline
      t.datetime :reserved_at
      t.string :reserved_by
      t.integer :reserved_number_of_members
      t.string :reference
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
