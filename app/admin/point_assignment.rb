ActiveAdmin.register PointAssignment do

permit_params :house_id, :staff_id, :activity_id, :school_id

index do
  selectable_column
	column :staff
	column :house
	column :member if Setting.where(:school_id => current_admin_user.school_id, key: "track-student-points").exists? && Setting.where(:school_id => current_admin_user.school_id, key: "track-student-points").first.value.downcase == "true"
  column :activity
  column :custom_points_title if Setting.where(:school_id => current_admin_user.school_id, key: "custom-points").exists? && Setting.where(:school_id => current_admin_user.school_id, key: "custom-points").first.value.downcase == "true"
  column :custom_points_amount if Setting.where(:school_id => current_admin_user.school_id, key: "custom-points").exists? && Setting.where(:school_id => current_admin_user.school_id, key: "custom-points").first.value.downcase == "true"
  column :note if Setting.where(:school_id => current_admin_user.school_id, key: "show-note-section").exists? && Setting.where(:school_id => current_admin_user.school_id, key: "show-note-section").first.value.downcase == "true"
  column :created_at
  actions
end

filter :staff, :collection => proc { Staff.where(:school_id => current_admin_user.school_id.to_s).all }
filter :house, :collection => proc { House.where(:school_id => current_admin_user.school_id).all }
filter :member, if: proc{ Setting.where(:school_id => current_admin_user.school_id, key: "track-student-points").exists? && Setting.where(:school_id => current_admin_user.school_id, key: "track-student-points").first.value.downcase == "true"}
filter :activity, :collection => proc { Activity.where(:school_id => current_admin_user.school_id).all }
filter :school, :collection => proc { School.all }, if: proc{ current_admin_user.school_id.nil?}

form do |f|
    f.inputs "Point Assignment" do
      f.input :staff, :collection => Staff.where(:school_id => current_admin_user.school_id.to_s).all
      f.input :house, :collection => House.where(:school_id => current_admin_user.school_id).all
      f.input :member, :collection => Member.where(:school_id => current_admin_user.school_id).all if Setting.where(:school_id => current_admin_user.school_id, key: "track-student-points").exists? && Setting.where(:school_id => current_admin_user.school_id, key: "track-student-points").first.value.downcase == "true"
      f.input :activity, :collection => Activity.where(:school_id => current_admin_user.school_id).all
      f.input :custom_points_title if Setting.where(:school_id => current_admin_user.school_id, key: "custom-points").exists? && Setting.where(:school_id => current_admin_user.school_id, key: "custom-points").first.value.downcase == "true"
      f.input :custom_points_amount if Setting.where(:school_id => current_admin_user.school_id, key: "custom-points").exists? && Setting.where(:school_id => current_admin_user.school_id, key: "custom-points").first.value.downcase == "true"
      f.input :note if Setting.where(:school_id => current_admin_user.school_id, key: "show-note-section").exists? && Setting.where(:school_id => current_admin_user.school_id, key: "show-note-section").first.value.downcase == "true"
    end
    f.actions
  end

controller do
    def scoped_collection
      if !current_admin_user.school_id.nil?
        PointAssignment.includes(:house).where("houses.school_id" => current_admin_user.school_id).all
      else
        PointAssignment.all
      end
    end
  end

  csv do
    column (:staff) {|assignment| assignment.staff.email}
    column (:house) {|assignment| assignment.house.name}
    column (:member){|assignment|  "N/A" || assignment.member.name if assignment.member_id.nil? } if Setting.where(:school_id => current_admin_user.school_id, key: "track-student-points").exists? && Setting.where(:school_id => current_admin_user.school_id, key: "track-student-points").first.value.downcase == "true"
    column (:activity) {|assignment| assignment.activity.name if !assignment.activity.nil?}
    column (:activity_points){|assignment| assignment.activity.points if !assignment.activity.nil?}
    column :custom_points_title if Setting.where(:school_id => current_admin_user.school_id, key: "custom-points").exists? && Setting.where(:school_id => current_admin_user.school_id, key: "custom-points").first.value.downcase == "true"
    column :custom_points_amount if Setting.where(:school_id => current_admin_user.school_id, key: "custom-points").exists? && Setting.where(:school_id => current_admin_user.school_id, key: "custom-points").first.value.downcase == "true"
    column :note if Setting.where(:school_id => current_admin_user.school_id, key: "show-note-section").exists? && Setting.where(:school_id => current_admin_user.school_id, key: "show-note-section").first.value.downcase == "true"
  end

end
