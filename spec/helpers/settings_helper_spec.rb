require "rails_helper"

RSpec.describe SettingsHelper, :type => :helper do
  before(:all) do
    @school = FactoryGirl.create(:school)
    @house = FactoryGirl.create(:house, :school => @school)
    @member = FactoryGirl.create(:member, :school => @school, :house => @house)
    @staff = FactoryGirl.create(:staff, :school => @school, :house => @house)
    @activity = FactoryGirl.create(:activity, :school => @school)
  end

  describe "#check_rate_limit" do
  	it "return true if rate limit field doesn't exist" do
  		params = {
  			"amount" => 1,

  		}
  		val = SettingsHelper.check_rate_limit(params, @school, @staff)
  		expect(val).to eq true
  	end

  	it "return true if rate limit field is false" do
  		params = {
  			"amount" => 1,

  		}
  		s = FactoryGirl.create(:setting, :key => "rate-limit", :value => "false", :school => @school)
  		val = SettingsHelper.check_rate_limit(params, @school, @staff)
  		expect(val).to eq true
  	end

  	it "return true if rate limit postive points hasn't been met" do
  		params = {
  			"amount" => 1,

  		}
  		FactoryGirl.create(:setting, :key => "rate-limit", :value => "true", :school => @school)
  		FactoryGirl.create(:setting, :key => "rate-limit-max-positive-points", :value => "1", :school => @school)
  		FactoryGirl.create(:setting, :key => "rate-limit-positive-reset-minutes", :value => "5", :school => @school)
  		
  		val = SettingsHelper.check_rate_limit(params, @school, @staff)
  		expect(val).to eq true
  	end

  	it "return the minutes if rate limit postive points has been met" do
  		params = {
  			"amount" => 5,

  		}
  		FactoryGirl.create(:setting, :key => "rate-limit", :value => "true", :school => @school)
  		FactoryGirl.create(:setting, :key => "rate-limit-max-positive-points", :value => "1", :school => @school)
  		FactoryGirl.create(:setting, :key => "rate-limit-positive-reset-minutes", :value => "5", :school => @school)
  		
  		val = SettingsHelper.check_rate_limit(params, @school, @staff)
  		expect(val).to eq 5
  	end

  	it "return true if rate limit negative points hasn't been met" do
  		params = {
  			"amount" => -1,

  		}
  		FactoryGirl.create(:setting, :key => "rate-limit", :value => "true", :school => @school)
  		FactoryGirl.create(:setting, :key => "rate-limit-max-negative-points", :value => "1", :school => @school)
  		FactoryGirl.create(:setting, :key => "rate-limit-negative-reset-minutes", :value => "5", :school => @school)
  		
  		val = SettingsHelper.check_rate_limit(params, @school, @staff)
  		expect(val).to eq true
  	end

  	it "return the minutes if rate limit negative points has been met" do
  		params = {
  			"amount" => -5,

  		}
  		FactoryGirl.create(:setting, :key => "rate-limit", :value => "true", :school => @school)
  		FactoryGirl.create(:setting, :key => "rate-limit-max-negative-points", :value => "1", :school => @school)
  		FactoryGirl.create(:setting, :key => "rate-limit-negative-reset-minutes", :value => "5", :school => @school)
  		
  		val = SettingsHelper.check_rate_limit(params, @school, @staff)
  		expect(val).to eq 5
  	end
  end

  describe "#check_note_required" do
  	it "returns true if note-required does not exist" do
  		val = SettingsHelper.check_note_required(params, @school)
  		expect(val).to eq true
  	end

  	it "returns true if note-required is false" do
  		FactoryGirl.create(:setting, :key => "note-required", :value => "false", :school => @school)
  		
  		val = SettingsHelper.check_note_required(params, @school)
  		expect(val).to eq true
  	end

  	it "return true if not value is set" do
  		FactoryGirl.create(:setting, :key => "note-required", :value => "true", :school => @school)
  		params = {
  			"note" => "something"
  		}
  		val = SettingsHelper.check_note_required(params, @school)
  		expect(val).to eq true
  	end

  	it "returns error if note is note set" do
  		FactoryGirl.create(:setting, :key => "note-required", :value => "true", :school => @school)
  		params = {}
  		val = SettingsHelper.check_note_required(params, @school)
  		expect(val).to eq "missing required note"
  	end
  end

  describe "#check_student_points" do
  	it "returns true if require-student-points does not exist" do
  		val = SettingsHelper.check_student_points(params, @school)
  		expect(val).to eq true
  	end

  	it "returns true if require-student-points is false" do
  		FactoryGirl.create(:setting, :key => "note-required", :value => "false", :school => @school)
  		
  		val = SettingsHelper.check_student_points(params, @school)
  		expect(val).to eq true
  	end

  	it "returns true if students are set" do
  		FactoryGirl.create(:setting, :key => "note-required", :value => "true", :school => @school)
  		params = {
  			"member_ids" => ["1","2","3","4","5"]
  		}
  		val = SettingsHelper.check_student_points(params, @school)
  		expect(val).to eq true
  	end

  	it "returns error if the students are missing" do
  		FactoryGirl.create(:setting, :key => "note-required", :value => "true", :school => @school)
  		params = {
  			"member_ids" => []
  		}
  		val = SettingsHelper.check_student_points(params, @school)
  		expect(val).to eq true
  	end
  end
end 