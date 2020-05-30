class AddEventStatusToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :event_status, :integer, default:0
    add_column :events, :initial_invitation_statement, :string
    add_column :events, :schedule_information_statement, :string
    add_column :events, :final_invitation_statement, :string
  end
end
