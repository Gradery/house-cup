# == Schema Information
#
# Table name: houses
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  color      :string(255)
#  points     :integer
#  school_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class House < ActiveRecord::Base
	belongs_to :school
	has_many :members
	has_many :staff
end
