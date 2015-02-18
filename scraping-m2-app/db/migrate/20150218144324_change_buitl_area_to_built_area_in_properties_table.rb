class ChangeBuitlAreaToBuiltAreaInPropertiesTable < ActiveRecord::Migration
  def change
  	rename_column :properties, :buitl_area, :built_area
  end
end
