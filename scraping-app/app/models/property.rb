class Property < ActiveRecord::Base
	has_many :scan_events
end
