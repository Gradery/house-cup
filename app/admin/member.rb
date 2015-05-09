ActiveAdmin.register Member do

permit_params :school_id, :house_id, :email, :name, :badge_id

index do
	column :house
	column :name
	column :badge_id
	column :email
	actions
end

filter :house
filter :name
filter :email
filter :badge_id

end
