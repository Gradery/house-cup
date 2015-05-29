ActiveAdmin.register PointAssignment do

permit_params :house_id, :staff_id, :activity_id, :school_id

index do
	column :staff
	column :house
	column :activity
	actions
end

filter :staff
filter :house
filter :activity

form do |f|
    f.inputs "Point Assignment" do
      f.input :staff
      f.input :house
      f.input :activity
    end
    f.actions
  end

controller do
    def scoped_collection
      PointAssignment.includes(:house).where("houses.school_id" => current_admin_user.school_id).all
    end
  end

end
