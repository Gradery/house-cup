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
  column (:school) {|activity| activity.school.name} if current_admin_user.school_id.nil?
	actions
end

filter :name
filter :points
filter :school, :collection => proc { School.all }, if: proc{ current_admin_user.school_id.nil?}

form do |f|
    f.inputs "Activity" do
      f.input :name
      f.input :points
      f.input :school, :collection => School.all if current_admin_user.school_id.nil?
    end
    f.actions
  end

controller do
	def scoped_collection
    if !current_admin_user.school_id.nil?
		  Activity.where(:school_id => current_admin_user.school_id).all
    else
      Activity.all
    end
	end

	def update
      if !current_admin_user.school_id.nil?
        params[:activity][:school_id] = current_admin_user.school_id
      end
      super
    end

    def create
      if !current_admin_user.school_id.nil?
        params[:activity][:school_id] = current_admin_user.school_id
      end
      super
    end
end

csv do
  column :name
  column :points
end

end
