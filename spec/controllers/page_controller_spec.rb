require "rails_helper"

RSpec.describe PageController, :type => :controller do

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
		sign_out(@staff)
		School.destroy_all
		Staff.destroy_all
		House.destroy_all
		Setting.destroy_all
		Member.destroy_all
		Activity.destroy_all
	end

	describe "#index" do
		it "sets @schools to be all schools" do
			get :index
			expect(assigns(:schools)).to eq School.all.to_a.sort_by{|h| h[:name]}
		end

		it "loads index template" do
			get :index
			expect(response).to render_template(:index)
		end
	end

	describe "#about" do
		it "has HTTP status 200 if the school exists" do
			get :about, :school => @school.url
			expect(response.status).to eq 200
		end

		it "renders correct template" do
			get :about, :school => @school.url
			expect(response).to render_template(:about)
		end
	end

	describe "#show" do
		it "sets house term if house term is set" do
			s = Setting.create(:school => @school, :key => "house-term", :value => "Group")
			get :show, :school => @school.url
			expect(assigns(:house_term)).to eq s.value
		end

		it "sets house term if house term is not set" do
			get :show, :school => @school.url
			expect(assigns(:house_term)).to eq "House"
		end

		it "gets and sorts houses" do
			get :show, :school => @school.url
			@houses = House.where(:school_id => @school.id).to_a
			@houses = @houses.sort_by {|h| h[:name].downcase }
			expect(assigns(:houses)).to eq @houses
		end

		it "doesn't show house text names if that setting is not set" do
			get :show, :school => @school.url
			expect(assigns(:showHouseTextNames)).to eq false
		end

		it "doesn't show house text names if that setting is false" do
			s = Setting.create(:school => @school, :key => "show-house-text-names", :value => "false")
			get :show, :school => @school.url
			expect(assigns(:showHouseTextNames)).to eq false
		end

		it "does show house text names if that setting is true" do
			s = Setting.create(:school => @school, :key => "show-house-text-names", :value => "true")
			get :show, :school => @school.url
			expect(assigns(:showHouseTextNames)).to eq true
		end
	end

	describe "#add" do
		it "redirects to the login page if the staff is not logged in" do
			get :add, :school => @school.url
			expect(response).to redirect_to("/staffs/sign_in")
		end

		it "sets correct column sizes" do
			sign_in(@staff)
			h1 = FactoryGirl.create(:house, :school => @school)
			get :add, :school => @school.url
			expect(assigns(:col_size_xs)).to eq 6
			expect(assigns(:col_size_sm)).to eq 2
			expect(assigns(:col_size_md)).to eq 2
			h2 = FactoryGirl.create(:house, :school => @school)
			get :add, :school => @school.url
			expect(assigns(:col_size_xs)).to eq 4
			expect(assigns(:col_size_sm)).to eq 4
			expect(assigns(:col_size_md)).to eq 4
		end

		it "doesn't show house text names if that setting is not set" do
			sign_in(@staff)
			get :add, :school => @school.url
			expect(assigns(:showHouseTextNames)).to eq false
		end

		it "doesn't show house text names if that setting is false" do
			sign_in(@staff)
			s = Setting.create(:school => @school, :key => "show-house-text-names", :value => "false")
			get :add, :school => @school.url
			expect(assigns(:showHouseTextNames)).to eq false
		end

		it "does show house text names if that setting is true" do
			sign_in(@staff)
			s = Setting.create(:school => @school, :key => "show-house-text-names", :value => "true")
			get :add, :school => @school.url
			expect(assigns(:showHouseTextNames)).to eq true
		end

		it "doesn't show notes section if that setting is not set" do
			sign_in(@staff)
			get :add, :school => @school.url
			expect(assigns(:show_note)).to eq false
		end

		it "doesn't show notes section if that setting is false" do
			sign_in(@staff)
			s = Setting.create(:school => @school, :key => "show-note-section", :value => "false")
			get :add, :school => @school.url
			expect(assigns(:show_note)).to eq false
		end

		it "does show notes section if that setting is true" do
			sign_in(@staff)
			s = Setting.create(:school => @school, :key => "show-note-section", :value => "true")
			get :add, :school => @school.url
			expect(assigns(:show_note)).to eq true
		end

		it "doesn't show student points if that setting is not set" do
			sign_in(@staff)
			get :add, :school => @school.url
			expect(assigns(:track_student)).to eq false
		end

		it "doesn't show student points if that setting is false" do
			sign_in(@staff)
			s = Setting.create(:school => @school, :key => "track-student-points", :value => "false")
			get :add, :school => @school.url
			expect(assigns(:track_student)).to eq false
		end

		it "does show student points if that setting is true" do
			sign_in(@staff)
			s = Setting.create(:school => @school, :key => "track-student-points", :value => "true")
			get :add, :school => @school.url
			expect(assigns(:track_student)).to eq true
		end

		it "doesn't show custom points if that setting is not set" do
			sign_in(@staff)
			get :add, :school => @school.url
			expect(assigns(:custom_points)).to eq false
		end

		it "doesn't show custom points if that setting is false" do
			sign_in(@staff)
			s = Setting.create(:school => @school, :key => "custom-points", :value => "false")
			get :add, :school => @school.url
			expect(assigns(:custom_points)).to eq false
		end

		it "does show custom points if that setting is true" do
			sign_in(@staff)
			s = Setting.create(:school => @school, :key => "custom-points", :value => "true")
			get :add, :school => @school.url
			expect(assigns(:custom_points)).to eq true
		end

		it "doesn't show multiple assignments if that setting is not set" do
			sign_in(@staff)
			get :add, :school => @school.url
			expect(assigns(:can_add_multiple)).to eq false
		end

		it "doesn't show multiple assignments if that setting is false" do
			sign_in(@staff)
			s = Setting.create(:school => @school, :key => "multiple-assignments", :value => "false")
			get :add, :school => @school.url
			expect(assigns(:can_add_multiple)).to eq false
		end

		it "does show multiple assignments if that setting is true" do
			sign_in(@staff)
			s = Setting.create(:school => @school, :key => "multiple-assignments", :value => "true")
			get :add, :school => @school.url
			expect(assigns(:can_add_multiple)).to eq true
		end
	end

	describe "#doadd" do
		it "lets you add custom points to a house" do
			sign_in(@staff)
			count = PointAssignment.count
			post :doadd, :custom_points => "true", :title => "title", :amount => "10", :note => "abc", :house => @house.id, :school => @school.url
			expect(PointAssignment.count).to eq (count+1)
		end

		it "lets you add custom points to an individual" do
			sign_in(@staff)
			count = PointAssignment.count
			post :doadd, :custom_points => "true", :title => "title", :amount => "10", :note => "abc", :member_ids => [@member.id], :school => @school.url
			expect(PointAssignment.count).to eq (count+1)
		end

		it "lets you add an existing activity to a house" do
			sign_in(@staff)
			count = PointAssignment.count
			post :doadd, :custom_points => "false", :activity => @activity.id, :note => "abc", :house => @house.id, :school => @school.url
			expect(PointAssignment.count).to eq (count+1)
		end

		it "lets you add an existing activity to an individual" do
			sign_in(@staff)
			count = PointAssignment.count
			post :doadd, :custom_points => "false", :activity => @activity.id, :note => "abc", :member_ids => [@member.id], :school => @school.url
			expect(PointAssignment.count).to eq (count+1)
		end
	end

	describe "#invite" do
		it "render the correct template" do
			get :invite, :school => @school.url, :id => @house.id
			expect(response).to render_template(:invite)
		end
	end

	describe "#doinvite" do
		it "has HTTP status 404 if the school does not exist" do
			post :doinvite, :school => "a", :id => @house.id
			expect(response.status).to eq 404
			expect(response.body).to eq "{\"error\":\"school not found\"}"
		end

		it "has HTTP status 401 if the house does not belong to the school" do
			@house.school = FactoryGirl.create(:school)
			@house.save!
			post :doinvite, :school => @school.url, :id => @house.id
			expect(response.status).to eq 401
			expect(response.body).to eq "{\"error\":\"house is not in listed school\"}"
		end

		it "creates a new member if everything is good" do
			count = Member.count
			post :doinvite, :school => @school.url, :id => @house.id, :name => "test user", :student_id => "1234"
			expect(response.status).to eq 200
			expect(Member.count).to eq (count+1)
		end
	end

	describe "#create_invite" do
		it "loads correct template" do
			get :create_invite, :school => @school.url
			expect(response).to render_template(:create_invite)
		end
	end

	describe "#do_create_invite" do
		it "loads the right template" do
			post :do_create_invite, :school => @school.url, :amount => 1
			expect(response).to render_template(:do_create_invite)
		end
	end

	describe "#students" do
		it "gets all members if no house is present" do
			sign_in(@staff)
			m = Member.create(:school => @school)
			get :students, :school => @school.url
			expect(response.body).to eq Member.where(:school => @school).all.to_a.sort_by{|a| a[:name]}.to_json
		end

		it "gets just house members if house is present" do
			sign_in(@staff)
			m = Member.create(:school => @school)
			get :students, :school => @school.url, :house => @house.id
			expect(response.body).to eq Member.where(:house => @house, school: @school).all.to_a.sort_by{|a| a[:name]}.to_json
		end
	end
end