ActiveAdmin.register PointAssignment do

permit_params :house_id, :staff_id, :activity_id, :school_id

index do
	column :staff
	column :house
	column :activity
	actions
end

filter :staff, :collection => proc { Staff.where(:school_id => current_admin_user.school_id).all }
filter :house, :collection => proc { House.where(:school_id => current_admin_user.school_id).all }
filter :activity, :collection => proc { Activity.where(:school_id => current_admin_user.school_id).all }

form do |f|
    f.inputs "Point Assignment" do
      f.input :staff, :collection => Staff.where(:school_id => current_admin_user.school_id).all
      f.input :house, :collection => House.where(:school_id => current_admin_user.school_id).all
      f.input :activity, :collection => Activity.where(:school_id => current_admin_user.school_id).all
    end
    f.actions
  end

controller do
    def scoped_collection
      PointAssignment.includes(:house).where("houses.school_id" => current_admin_user.school_id).all
    end
  end

end
