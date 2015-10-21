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

require "rails_helper"

RSpec.describe School, :type => :model do
	before(:each) do
		School.destroy_all
	end

	it "has a working FacotryGirl Model" do
		a = FactoryGirl.build(:school)
		expect(a.valid?).to eq true
	end

	it "will not create without a name" do
		a = FactoryGirl.build(:school)
		a.name = nil
		expect(a.valid?).to eq false
		expect(a.errors.messages.to_json).to eq "{\"name\":[\"can't be blank\"]}"
	end

	it "will not create without a url" do
		a = FactoryGirl.build(:school)
		a.url = nil
		expect(a.valid?).to eq false
		expect(a.errors.messages.to_json).to eq "{\"url\":[\"can't be blank\"]}"
	end

	it "will not create without a unique url" do
		a = FactoryGirl.create(:school)
		b = FactoryGirl.build(:school)
		b.url = a.url
		expect(b.valid?).to eq false
		expect(b.errors.messages.to_json).to eq "{\"url\":[\"has already been taken\"]}"
	end
end