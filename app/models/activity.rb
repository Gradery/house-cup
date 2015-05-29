# == Schema Information
#
# Table name: activities
#
#  id         :integer          not null, primary key
#  name       :text
#  points     :integer
#  school_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Activity < ActiveRecord::Base
	belongs_to :school

	validates :name, :points, :school_id, presence: true
end
