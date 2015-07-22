ActiveAdmin.register Staff do

permit_params :email, :school_id, :house_id, :password, :password_confirmation, :grade

index do
    selectable_column
    column :email
    column :house
    column :grade
    actions
  end

  filter :email
  filter :house, :collection => proc { House.where(:school_id => current_admin_user.school_id).all }

  form do |f|
    f.inputs "Staff Details" do
      f.input :email
      f.input :password if !resource.valid?
      f.input :password_confirmation if !resource.valid?
      f.input :house, :collection => House.where(:school_id => current_admin_user.school_id).all
      f.input :grade, :collection => Setting.where(:school_id => current_admin_user.school_id.to_i, :key => "grades").first.value.split(",")
    end
    f.actions
  end

  controller do
    def scoped_collection
      Staff.where(:school_id => current_admin_user.school_id.to_s).all
    end
  end

  controller do
    def update
      if params[:staff][:password].blank? && params[:staff][:password_confirmation].blank?
        params[:staff].delete("password")
        params[:staff].delete("password_confirmation")
      end
      params[:staff][:school_id] = current_admin_user.school_id
      super
    end
  end

  csv do
    column :email
    column (:house) {|staff| staff.house.name}
  end

end
