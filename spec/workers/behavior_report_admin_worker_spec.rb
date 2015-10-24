require "rails_helper"
require 'sidekiq/testing'

RSpec.describe BehaviorReportAdminWorker do
  before(:all) do
    @school = FactoryGirl.create(:school)
    @house = FactoryGirl.create(:house, :school => @school)
    @member = FactoryGirl.create(:member, :school => @school, :house => @house)
    @staff = FactoryGirl.create(:staff, :school => @school, :house => @house)
    @activity = FactoryGirl.create(:activity, :school => @school)
    FactoryGirl.create(:activity_assignment, :staff => @staff, :house => @house, :activity => @activity, :member => @member)
    FactoryGirl.create(:activity_assignment, :staff => @staff, :house => @house, :activity => @activity, :member => @member)
    FactoryGirl.create(:activity_assignment, :staff => @staff, :house => @house, :activity => @activity, :member => @member)
    a = FactoryGirl.create(:custom_point_assignment, :staff => @staff, :house => @house, :member => @member)
    FactoryGirl.create(:custom_point_assignment, :custom_points_title => a.custom_points_title, :staff => @staff, :house => @house, :member => @member)
    FactoryGirl.create(:custom_point_assignment, :custom_points_title => a.custom_points_title,:staff => @staff, :house => @house, :member => @member)
    FactoryGirl.create(:custom_point_assignment, :custom_points_title => a.custom_points_title,:staff => @staff, :house => @house, :member => @member)
    FactoryGirl.create(:custom_point_assignment, :custom_points_title => a.custom_points_title,:staff => @staff, :house => @house, :member => @member)
    @admin_user = FactoryGirl.create(:admin_user, :school => @school)
    Sidekiq::Testing.inline!
  end

  it "runs successfully" do
  	BehaviorReportAdminWorker.perform_async(@member.id, @admin_user.id)
  end
end