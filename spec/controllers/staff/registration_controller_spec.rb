require "rails_helper"

RSpec.describe Staff::RegistrationsController, :type => :controller do
	before(:each) do
		School.destroy_all
		@school = FactoryGirl.create(:school)
		@house = FactoryGirl.create(:house, :school => @school)
		@staff = FactoryGirl.create(:staff, :school_id => @school.id, :house => @house)
		@member = FactoryGirl.create(:member, :school => @school, :house => @house)
		@activity = FactoryGirl.create(:activity, :school => @school)
		s = Setting.create(:school => @school, :key => "grades", :value => "1,2,3,4,5,6,7,8,9,10,11,12,other")
	end

	after(:each) do
		#sign_out(@staff)
		School.destroy_all
		Staff.destroy_all
		House.destroy_all
		Setting.destroy_all
		Member.destroy_all
		Activity.destroy_all
	end

	describe "#edit" do
		it "sets @school to the staff's school" do
			@request.env["devise.mapping"] = Devise.mappings[:staff]
			sign_in(@staff)
			get :edit
			expect(assigns(:school)).to eq @staff.school
		end

		it "sets @students to the staff's school" do
			@request.env["devise.mapping"] = Devise.mappings[:staff]
			sign_in(@staff)
			get :edit
			expect(assigns(:school)).to eq @staff.school
		end

		it "sets @students to the staff's students they have assigned points to" do
			@request.env["devise.mapping"] = Devise.mappings[:staff]
			sign_in(@staff)
			get :edit
			expect(assigns(:students)).to eq PointAssignment.where(:staff => @staff).all.map{|a| a.member}.uniq.delete_if{|a| a.nil?}.sort_by{|a| a.name }
		end

		it "sets @members to the staff's members in the school" do
			@request.env["devise.mapping"] = Devise.mappings[:staff]
			sign_in(@staff)
			get :edit
			expect(assigns(:members)).to eq Member.where(:school_id => @school.id).all.sort_by{|m| m.name.downcase }
		end
	end
end