class AddOldPriceAndNewPriceToScanEventTable < ActiveRecord::Migration
  def change
  	add_column :scan_events, :old_price, :integer, :limit => 8
  	add_column :scan_events, :new_price, :integer, :limit => 8
  end
end
