ActiveAdmin.register PointAssignment do

permit_params :house_id, :staff_id, :activity_id

index do
	column :staff
	column :house
	column :activity
	actions
end

filter :staff
filter :house
filter :activity

end
