require "rails_helper"

RSpec.describe ApiController, :type => :controller do
	describe "#houses" do
		it "has HTTP 400 if there is no current_admin_user" do
			get :houses
			expect(response.status).to eq 400
		end

		it "has HTTP 200 if there is a current_admin_user" do
			admin_user = FactoryGirl.create(:admin_user)
			sign_in admin_user
			get :houses
			expect(response.status).to eq 200
		end
	end

	describe "#house_points_by_activity" do
		it "has HTTP 400 if there is no current_admin_user" do
			get :house_points_by_activity
			expect(response.status).to eq 400
		end

		it "has HTTP 200 if there is a current_admin_user" do
			admin_user = FactoryGirl.create(:admin_user)
			sign_in admin_user
			get :house_points_by_activity
			expect(response.status).to eq 200
		end
	end

	describe "#staff" do
		it "has HTTP 400 if there is no current_admin_user" do
			get :staff
			expect(response.status).to eq 400
		end

		it "has HTTP 200 if there is a current_admin_user" do
			admin_user = FactoryGirl.create(:admin_user)
			sign_in admin_user
			get :staff
			expect(response.status).to eq 200
		end
	end

	describe "#staff_assignment_by_activity" do
		it "has HTTP 400 if there is no current_admin_user" do
			get :staff_assignment_by_activity
			expect(response.status).to eq 400
		end

		it "has HTTP 200 if there is a current_admin_user" do
			admin_user = FactoryGirl.create(:admin_user)
			sign_in admin_user
			get :staff_assignment_by_activity
			expect(response.status).to eq 200
		end
	end

	describe "#top_points" do
		it "has HTTP 400 if there is no current_admin_user" do
			get :top_points
			expect(response.status).to eq 400
		end

		it "has HTTP 200 if there is a current_admin_user" do
			admin_user = FactoryGirl.create(:admin_user)
			sign_in admin_user
			get :top_points
			expect(response.status).to eq 200
		end
	end

	describe "#member_behavior_report" do
		it "has HTTP 400 if there is no current_staff" do
			get :member_behavior_report
			expect(response.status).to eq 400
		end

		it "has HTTP 200 if there is a current_staff" do
			staff = FactoryGirl.create(:staff)
			sign_in staff
			get :member_behavior_report
			expect(response.status).to eq 200
		end
	end
end