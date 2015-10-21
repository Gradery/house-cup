# == Schema Information
#
# Table name: admin_users
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
#  school_id              :integer
#  deleted_at             :datetime
#

require "rails_helper"

RSpec.describe AdminUser, :type => :model do
	before(:all) do
		@school = FactoryGirl.create(:school)
	end

	it "creates a user without a school" do
		a = FactoryGirl.build(:admin_user)
		a.school = nil
		expect(a.valid?).to eq true
	end

	it "creates a user with a school" do
		a = FactoryGirl.build(:admin_user)
		expect(a.valid?).to eq true
	end
end