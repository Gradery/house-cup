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

require "rails_helper"

RSpec.describe Activity, :type => :model do
	before(:all) do
		@school = FactoryGirl.create(:school)
	end
	
	it "has a working FactoryGirl instance" do
		a = FactoryGirl.build(:activity, :school => @school)
		expect(a.valid?).to eq true
	end

	it "will not create an instance without a name" do
		a = FactoryGirl.create(:activity, :school => @school)
		a.name = nil
		expect(a.valid?).to eq false
		expect(a.errors.messages.to_json).to eq "{\"name\":[\"can't be blank\"]}"
	end

	it "will not create an instance without points" do
		a = FactoryGirl.create(:activity, :school => @school)
		a.points = nil
		expect(a.valid?).to eq false
		expect(a.errors.messages.to_json).to eq "{\"points\":[\"can't be blank\"]}"
	end

	it "will not create an instance without a school_id" do
		a = FactoryGirl.create(:activity, :school => @school)
		a.school_id = nil
		expect(a.valid?).to eq false
		expect(a.errors.messages.to_json).to eq "{\"school_id\":[\"can't be blank\"]}"
	end
end
