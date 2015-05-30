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
#

class School < ActiveRecord::Base
	has_many :houses
	has_many :staff
	has_many :members

	validates :name, :url, presence: true
end
