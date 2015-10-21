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

require "rails_helper"

RSpec.describe Setting, :type => :model do

	before(:each) do 
		School.with_deleted.all.each{|a| a.really_destroy!}
		@school = FactoryGirl.create(:school)
	end

	it "has a working FacotryGirl Model" do
		a = FactoryGirl.build(:setting, school: @school)
		expect(a.valid?).to eq true
	end

	it "will not create without a school_id" do
		a = FactoryGirl.build(:setting, school: @school)
		a.school_id = nil
		expect(a.valid?).to eq false
		expect(a.errors.messages.to_json).to eq "{\"school_id\":[\"can't be blank\"]}"
	end

	it "will not create without a key" do
		a = FactoryGirl.build(:setting, school: @school)
		a.key = nil
		expect(a.valid?).to eq false
		expect(a.errors.messages.to_json).to eq "{\"key\":[\"can't be blank\"]}"
	end

	it "will not create without a value" do
		a = FactoryGirl.build(:setting, school: @school)
		a.value = nil
		expect(a.valid?).to eq false
		expect(a.errors.messages.to_json).to eq "{\"value\":[\"can't be blank\"]}"
	end
end