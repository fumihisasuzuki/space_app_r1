class AddRemarkToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :remark, :string
  end
end
