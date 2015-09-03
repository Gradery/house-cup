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
#  deleted_at :datetime
#

class Activity < ActiveRecord::Base
	acts_as_paranoid
	
	belongs_to :school

	validates :name, :points, :school_id, presence: true
end
