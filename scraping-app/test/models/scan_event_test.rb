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

require 'test_helper'

class ScanEventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
