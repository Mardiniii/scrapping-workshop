# == Schema Information
#
# Table name: scan_events
#
#  id          :integer          not null, primary key
#  property_id :integer
#  event_type  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ScanEvent < ActiveRecord::Base
	enum event_type: [:new_propertie, :change_price, :removed_propertie]
  belongs_to :property
end
