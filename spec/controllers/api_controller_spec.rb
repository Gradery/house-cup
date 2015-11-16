require "rails_helper"

RSpec.describe ApiController, :type => :controller do
	describe "#houses" do
		it "has HTTP 400 if there is no current_admin_user" do
			get :houses
			expect(response.status).to eq 400
		end

		it "has HTTP 200 if there is a current_admin_user" do
			admin_user = FactoryGirl.create(:admin_user)
			activity = FactoryGirl.create(:activity, :school => admin_user.school)
			sign_in admin_user
			@request.env["HTTP_ACCEPT"] = "application/json"
 			@request.env["CONTENT_TYPE"] = "application/json"
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
			activity = FactoryGirl.create(:activity, :school => admin_user.school)
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
			activity = FactoryGirl.create(:activity, :school => admin_user.school)
			sign_in admin_user
			@request.env["HTTP_ACCEPT"] = "application/json"
 			@request.env["CONTENT_TYPE"] = "application/json"
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
			activity = FactoryGirl.create(:activity, :school => admin_user.school)
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
			activity = FactoryGirl.create(:activity, :school => admin_user.school)
			house = FactoryGirl.create(:house, :school => admin_user.school)
			# set up a custom point point assignment
			custom = PointAssignment.new
			custom.custom_points = true
			custom.custom_points_title = "test"
			custom.custom_points_amount = 1
			custom.staff = FactoryGirl.create(:staff, :school_id => admin_user.school.id, :house => house)
			custom.member = FactoryGirl.create(:member, :school => admin_user.school, :house => custom.staff.house)
			custom.house = house
			custom.save!
			# now set up one assignment set to the activity
			non_custom = PointAssignment.new
			non_custom.custom_points = false
			non_custom.activity = activity
			non_custom.staff = FactoryGirl.create(:staff, :school_id => admin_user.school.id, :house => house)
			non_custom.member = FactoryGirl.create(:member, :school => admin_user.school, :house => custom.staff.house)
			non_custom.house = house
			non_custom.save!
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