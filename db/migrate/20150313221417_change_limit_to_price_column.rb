class ChangeLimitToPriceColumn < ActiveRecord::Migration
  def change
  	remove_column :properties, :sale_value
  	remove_column :properties, :meter_squared_value
  	remove_column :scan_events, :old_price
  	remove_column :scan_events, :new_price

  	add_column :properties, :sale_value, "BIGINT"
  	add_column :properties, :meter_squared_value, "BIGINT"
  	add_column :scan_events, :old_price, "BIGINT"
  	add_column :scan_events, :new_price, "BIGINT"
  end
end
