ActiveAdmin.register Setting do

permit_params :school_id, :key, :value

index do
	column :key
	column :value
	actions
end

filter :key
filter :value

form do |f|
    f.inputs "Setting" do
      f.input :key
      f.input :value
    end
    f.actions
  end

controller do
  def scoped_collection
    Setting.where(:school_id => current_admin_user.school_id).all
  end

  def update
    params[:setting][:school_id] = current_admin_user.school_id
    super
  end

  def create
    params[:setting][:school_id] = current_admin_user.school_id
    super
  end
end

end
