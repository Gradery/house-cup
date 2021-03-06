# == Schema Information
#
# Table name: point_assignments
#
#  id                   :integer          not null, primary key
#  staff_id             :integer
#  house_id             :integer
#  activity_id          :integer
#  created_at           :datetime
#  updated_at           :datetime
#  deleted_at           :datetime
#  note                 :text
#  member_id            :integer
#  custom_points        :boolean          default(FALSE)
#  custom_points_title  :text
#  custom_points_amount :integer
#

FactoryGirl.define do
  factory :point_assignment do
  	staff
  	house
  	member
  	note { Faker::Lorem.paragraph }
  	factory :custom_point_assignment do
  		custom_points true
  		custom_points_title { Faker::Company.name }
  		custom_points_amount { Faker::Number.number(2) }
  	end
  	factory :activity_assignment do
  		activity
  	end
  end 
end