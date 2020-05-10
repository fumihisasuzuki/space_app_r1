class CreateMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :members do |t|
      t.string :member_name, null: false
      t.string :email
      t.string :line
      t.string :comment
      t.integer :column_number
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
