class CreateShops < ActiveRecord::Migration[5.1]
  def change
    create_table :shops do |t|
      t.string :shop_name
      t.string :shop_url
      t.string :shop_station
      t.string :shop_telephonenumber
      t.string :shop_address
      t.string :course
      t.string :remark
      t.boolean :decided
      t.integer :price
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
