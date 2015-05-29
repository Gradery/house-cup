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

form do |f|
    f.inputs "Activity" do
      f.input :name
      f.input :points
    end
    f.actions
  end

controller do
	def scoped_collection
		Activity.where(:school_id => current_admin_user.school_id).all
	end

	def update
      params[:activity][:school_id] = current_admin_user.school_id
      super
    end

    def create
      params[:activity][:school_id] = current_admin_user.school_id
      super
    end
end

end
