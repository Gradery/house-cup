class ReportMailer < ActionMailer::Base
  default from: "noreply@gradery.com"

  def email_staff(staff_id, file_url)
    @staff = Staff.find(staff_id)
    @file_url = file_url
    mail(:to=>@staff.email,
         :subject=>"House Cup: Your Requested Behavior Reports")
  end
end