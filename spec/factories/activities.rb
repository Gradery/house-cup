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

FactoryGirl.define do
  factory :activity do
  	name { Faker::Name.name  }
  	points 1
  end 
end