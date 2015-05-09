# == Schema Information
#
# Table name: point_assignments
#
#  id          :integer          not null, primary key
#  staff_id    :integer
#  house_id    :integer
#  activity_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class PointAssignment < ActiveRecord::Base
	belongs_to :staff
	belongs_to :house
	belongs_to :activity
end
