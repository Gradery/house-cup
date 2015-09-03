ActiveAdmin.register PointAssignment do

permit_params :house_id, :staff_id, :activity_id, :school_id

index do
	column :staff
	column :house
	column :activity
  column :note if Setting.where(:school_id => current_admin_user.school_id, key: "show-note-section").exists? && Setting.where(:school_id => current_admin_user.school_id, key: "show-note-section").first.value.downcase == "true"
  column :created_at
  actions
end

filter :staff, :collection => proc { Staff.where(:school_id => current_admin_user.school_id.to_s).all }
filter :house, :collection => proc { House.where(:school_id => current_admin_user.school_id).all }
filter :activity, :collection => proc { Activity.where(:school_id => current_admin_user.school_id).all }
filter :school, :collection => proc { School.all }, if: proc{ current_admin_user.school_id.nil?}

form do |f|
    f.inputs "Point Assignment" do
      f.input :staff, :collection => Staff.where(:school_id => current_admin_user.school_id.to_s).all
      f.input :house, :collection => House.where(:school_id => current_admin_user.school_id).all
      f.input :activity, :collection => Activity.where(:school_id => current_admin_user.school_id).all
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
    column (:activity) {|assignment| assignment.activity.name}
    column :note if Setting.where(:school_id => current_admin_user.school_id, key: "show-note-section").exists? && Setting.where(:school_id => current_admin_user.school_id, key: "show-note-section").first.value.downcase == "true"
  end

end
