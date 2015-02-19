# == Schema Information
#
# Table name: properties
#
#  id                  :integer          not null, primary key
#  market              :string
#  property_type       :string
#  date                :datetime
#  stratum             :integer
#  city                :string
#  neighborhood        :string
#  built_area          :integer
#  sale_value          :integer
#  meter_squared_value :integer
#  rooms_number        :integer
#  property_code       :string
#  rotation_days       :integer
#  url                 :string
#  source              :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Property < ActiveRecord::Base
end
