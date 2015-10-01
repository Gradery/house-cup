# == Schema Information
#
# Table name: members
#
#  id         :integer          not null, primary key
#  school_id  :integer
#  house_id   :integer
#  badge_id   :string(255)
#  email      :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#  grade      :string(255)
#

FactoryGirl.define do
  factory :member do
  	name { Faker::Name.name  }
  	badge_id { Faker::Number.number(10) }
  	grade "6"
  end 
end