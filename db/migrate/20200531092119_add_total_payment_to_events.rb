class AddTotalPaymentToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :total_payment, :integer, default:0
    add_column :events, :fee_unit, :integer, default:100
    add_column :events, :rate_of_fee_slope, :float, default:1.5
    add_column :events, :calculation_method_type, :integer, default:0
    add_column :users, :number_of_members_per_one_page, :integer, default:10
  end
end
