# == Schema Information
#
# Table name: schools
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  url        :string(255)
#  about      :text
#  deleted_at :datetime
#

class School < ActiveRecord::Base
	acts_as_paranoid
	
	has_many :houses
	has_many :staff
	has_many :members

	validates :name, :url, presence: true
end
