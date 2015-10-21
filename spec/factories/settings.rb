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
FactoryGirl.define do
  factory :setting do
  	key { Faker::Lorem.word }
  	value { Faker::Lorem.word }
  	school
  end 
end
