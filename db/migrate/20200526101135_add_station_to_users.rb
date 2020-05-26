class AddStationToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :station, :string, default: ""
    add_column :users, :map_url, :string, null: false, default: "https://www.google.co.jp/maps/"
    add_column :events, :station, :string, default: ""
  end
end
