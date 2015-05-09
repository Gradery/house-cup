# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  key        :string(255)
#  value      :string(255)
#  school_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Setting < ActiveRecord::Base
	belongs_to :school
end
