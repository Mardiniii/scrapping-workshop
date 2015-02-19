class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :market
      t.string :property_type
      t.datetime :date
      t.integer :stratum
      t.string :city
      t.string :neighborhood
      t.integer :built_area
      t.integer :sale_value, :limit => 8
      t.integer :meter_squared_value
      t.integer :rooms_number
      t.string :property_code
      t.integer :rotation_days
      t.string :url
      t.string :source

      t.timestamps null: false
    end
  end
end
