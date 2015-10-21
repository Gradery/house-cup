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

require "rails_helper"

RSpec.describe Member, :type => :model do
	before(:all) do
		@school = FactoryGirl.create(:school)
	end

	it "has a working FacotryGirl Model" do
		a = FactoryGirl.build(:member)
		expect(a.valid?).to eq true
	end

	it "will not create without a badge_id" do
		a = FactoryGirl.build(:member)
		a.badge_id = nil
		expect(a.valid?).to eq false
		expect(a.errors.messages.to_json).to eq "{\"badge_id\":[\"can't be blank\"]}"
	end

	it "will not create if badge_id is blank" do
		a = FactoryGirl.build(:member)
		a.badge_id = ""
		expect(a.valid?).to eq false
		expect(a.errors.messages.to_json).to eq "{\"badge_id\":[\"can't be blank\"]}"
	end
end