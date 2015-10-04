class ReportMailer < ActionMailer::Base
  default from: "noreply@gradery.com"

  def email_staff(staff_id, file_url)
    @staff = Staff.find(staff_id)
    @file_url = file_url
    mail(:to=>@staff.email,
         :subject=>"House Cup: Your Requested Behavior Reports")
  end

  def email_admin(admin_id, member, file_url)
  	@admin_user = AdminUser.find(admin_id)
  	@member = member
  	@file_url = file_url
  	mail(:to=>@admin_user.email,
         :subject=>"House Cup: Admin Behavior Report for "+@member.name)
  end
end