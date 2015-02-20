class CreateScanEvents < ActiveRecord::Migration
  def change
    create_table :scan_events do |t|
      t.references :property, index: true
      t.integer :event_type

      t.timestamps null: false
    end
    add_foreign_key :scan_events, :properties
  end
end
