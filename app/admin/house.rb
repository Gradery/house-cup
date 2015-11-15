ActiveAdmin.register House do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :name, :color, :points, :school_id, :image

index do
  selectable_column
	column :name
	column :points
  column (:school) {|house| house.school.name} if current_admin_user.school_id.nil?
	actions
end

filter :name
filter :school, :collection => proc { School.all }, if: proc{ current_admin_user.school_id.nil?}


form do |f|
    f.inputs "House" do
      f.input :name
      f.input :color
      f.input :points
      f.input :image
      f.input :school, :collection => School.all if current_admin_user.school_id.nil?
    end
    f.actions
  end

controller do
    def scoped_collection
      if !current_admin_user.school_id.nil?
        House.where(:school_id => current_admin_user.school_id).all
      else
        House.all
      end
    end

    def update
      if !current_admin_user.school_id.nil?
	       params[:house][:school_id] = current_admin_user.school_id
      end
	    super
	  end

	  def create
	    if !current_admin_user.school_id.nil?
        params[:house][:school_id] = current_admin_user.school_id
      end
	    super
	  end
  end

  csv do
    column :name
    column :points
    column :color
  end

end
