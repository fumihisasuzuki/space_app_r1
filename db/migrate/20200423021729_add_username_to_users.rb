class AddUsernameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :user_name, :string, null: false, default: "Guest"
    add_column :users, :admin, :boolean, null: false, default: false
    add_column :users, :web_search_url, :string, null: false, default: "https://www.google.co.jp/"
    add_column :users, :train_search_url, :string, null: false, default: "https://transit.yahoo.co.jp/"
    add_column :users, :days_before, :integer, null: false, default: 1
    add_column :users, :provider, :string
    add_column :users, :uid, :string
  end
end
