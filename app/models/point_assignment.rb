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
#  deleted_at  :datetime
#  note        :text
#  member_id   :integer
#

class PointAssignment < ActiveRecord::Base
	acts_as_paranoid
	
	belongs_to :staff
	belongs_to :house
	belongs_to :activity
	belongs_to :member

	validates :staff_id, :house_id, :activity_id, presence: true
end
