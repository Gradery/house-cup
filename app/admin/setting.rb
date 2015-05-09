ActiveAdmin.register Setting do

permit_params :school_id, :key, :value

index do
	column :key
	column :value
	actions
end

filter :key
filter :value

end
