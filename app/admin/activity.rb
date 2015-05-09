ActiveAdmin.register Activity do

permit_params :school_id, :name, :points

show do
	attributes_table do
	  row :name
	  row :points
	end
	active_admin_comments
end

index do
	column :name
	column :points
	actions
end

filter :name
filter :points

end
