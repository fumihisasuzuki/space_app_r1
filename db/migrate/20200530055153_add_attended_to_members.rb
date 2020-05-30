class AddAttendedToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :attended, :boolean, null: false, default: false
  end
end
