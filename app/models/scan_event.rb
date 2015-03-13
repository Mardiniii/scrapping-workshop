# == Schema Information
#
# Table name: scan_events
#
#  id          :integer          not null, primary key
#  property_id :integer
#  event_type  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  old_price   :integer
#  new_price   :integer
#

class ScanEvent < ActiveRecord::Base
	enum event_type: [:new_property, :change_price, :removed_property]
  belongs_to :property
end
