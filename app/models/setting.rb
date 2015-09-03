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
#  deleted_at :datetime
#

class Setting < ActiveRecord::Base
	acts_as_paranoid
	
	belongs_to :school

	validates :key, :value, :school_id, presence: true
end
