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

require "rails_helper"

RSpec.describe PointAssignment, :type => :model do
	before(:all) do
		@school = FactoryGirl.create(:school)
	end

	it "has a working FacotryGirl Models" do
		a = FactoryGirl.build(:point_assignment)
		expect(a.valid?).to eq true
		a = FactoryGirl.build(:custom_point_assignment)
		expect(a.valid?).to eq true
		a = FactoryGirl.build(:activity_assignment)
		expect(a.valid?).to eq true
	end

	it "will not create without a staff_id" do
		a = FactoryGirl.build(:point_assignment)
		a.staff_id = nil
		expect(a.valid?).to eq false
		expect(a.errors.messages.to_json).to eq "{\"staff_id\":[\"can't be blank\"]}"
	end

	it "will not create without a house_id" do
		a = FactoryGirl.build(:point_assignment)
		a.house_id = nil
		expect(a.valid?).to eq false
		expect(a.errors.messages.to_json).to eq "{\"house_id\":[\"can't be blank\"]}"
	end
end