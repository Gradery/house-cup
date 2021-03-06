# == Schema Information
#
# Table name: staffs
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  school_id              :string(255)
#  house_id               :integer
#  grade                  :string(255)
#  deleted_at             :datetime
#  name                   :string(255)
#

require "rails_helper"

RSpec.describe Staff, :type => :model do

	it "has a working FacotryGirl Model" do
		a = FactoryGirl.build(:staff)
		expect(a.valid?).to eq true
	end

	it "will not create without a house_id" do
		a = FactoryGirl.build(:staff)
		a.house_id = nil
		expect(a.valid?).to eq false
		expect(a.errors.messages.to_json).to eq "{\"house_id\":[\"can't be blank\"]}"
	end

	it "will not create without a school_id" do
		a = FactoryGirl.build(:staff)
		a.school_id = nil
		expect(a.valid?).to eq false
		expect(a.errors.messages.to_json).to eq "{\"school_id\":[\"can't be blank\"]}"
	end

	it "returns the email when to_s is called" do
		a = FactoryGirl.create(:staff)
		expect(a.to_s).to eq a.email
	end
end