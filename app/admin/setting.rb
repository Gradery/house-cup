ActiveAdmin.register Setting do

permit_params :school_id, :key, :value

index do
	column :key
	column :value
  column :school, if: proc{ current_admin_user.school_id.nil?}
	actions
end

filter :key
filter :value
filter :school, :collection => proc { School.all }, if: proc{ current_admin_user.school_id.nil?}

form do |f|
    f.inputs "Setting" do
      f.input :key
      f.input :value
      f.input :school, :collection => School.all if current_admin_user.school_id.nil?
    end
    f.actions
  end

controller do
  def scoped_collection
    if !current_admin_user.school_id.nil?
      Setting.where(:school_id => current_admin_user.school_id).all
    else
      Setting.all
    end
  end

  def update
    if !current_admin_user.school_id.nil?
      params[:setting][:school_id] = current_admin_user.school_id
    end
    super
  end

  def create
    if !current_admin_user.school_id.nil?
      params[:setting][:school_id] = current_admin_user.school_id
    end
    super
  end
end

end
