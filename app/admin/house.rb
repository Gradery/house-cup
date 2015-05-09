ActiveAdmin.register House do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :name, :color, :points, :school_id

index do
	column :name
	column :points
	actions
end

filter :name


end
