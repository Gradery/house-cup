ActiveAdmin.register House do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :name, :color, :points, :school_id, :image

index do
	column :name
	column :points
	actions
end

filter :name

form do |f|
    f.inputs "House" do
      f.input :name
      f.input :color
      f.input :points
      f.input :image
    end
    f.actions
  end

controller do
    def scoped_collection
      House.where(:school_id => current_admin_user.school_id).all
    end

    def update
	    params[:house][:school_id] = current_admin_user.school_id
	    super
	  end

	  def create
	    params[:house][:school_id] = current_admin_user.school_id
	    super
	  end
  end

  csv do
    column :name
    column :points
    column :color
  end

end
