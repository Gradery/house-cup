# == Schema Information
#
# Table name: houses
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  color              :string(255)
#  points             :integer
#  school_id          :integer
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  deleted_at         :datetime
#

require "rails_helper"

RSpec.describe House, :type => :model do
	before(:all) do
		@school = FactoryGirl.create(:school)
	end

	it "has a working FacotryGirl Model" do
		a = FactoryGirl.build(:house)
		expect(a.valid?).to eq true
	end

	it "will not create a house without a name" do
		a = FactoryGirl.build(:house)
		a.name = nil
		expect(a.valid?).to eq false
		expect(a.errors.messages.to_json).to eq "{\"name\":[\"can't be blank\"]}"
	end

	it "will not create a house if name is blank" do
		a = FactoryGirl.build(:house)
		a.name = ""
		expect(a.valid?).to eq false
		expect(a.errors.messages.to_json).to eq "{\"name\":[\"can't be blank\"]}"
	end

	it "will not create a house without a color" do
		a = FactoryGirl.build(:house)
		a.color = nil
		expect(a.valid?).to eq false
		expect(a.errors.messages.to_json).to eq "{\"color\":[\"can't be blank\"]}"
	end

	it "will not create a house if color is blank" do
		a = FactoryGirl.build(:house)
		a.color = ""
		expect(a.valid?).to eq false
		expect(a.errors.messages.to_json).to eq "{\"color\":[\"can't be blank\"]}"
	end

	it "will not create a house without points" do
		a = FactoryGirl.build(:house)
		a.points = nil
		expect(a.valid?).to eq false
		expect(a.errors.messages.to_json).to eq "{\"points\":[\"can't be blank\"]}"
	end

	it "will not create a house without a school_id" do
		a = FactoryGirl.build(:house)
		a.school_id = nil
		expect(a.valid?).to eq false
		expect(a.errors.messages.to_json).to eq "{\"school_id\":[\"can't be blank\"]}"
	end
end