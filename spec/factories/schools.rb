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

FactoryGirl.define do
  factory :school do
  	name { Faker::Name.name  }
  	url { Faker::Internet.domain_word }
  	about { Faker::Lorem.paragraph }
  end 
end