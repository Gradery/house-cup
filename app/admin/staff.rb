ActiveAdmin.register Staff do

permit_params :email, :school_id, :house_id, :password, :password_confirmation

index do
    selectable_column
    id_column
    column :email
    actions
  end

  filter :email

  form do |f|
    f.inputs "Staff Details" do
      f.input :email
      f.input :password if !resource.valid?
      f.input :password_confirmation if !resource.valid?
      f.input :house
    end
    f.actions
  end

  controller do
    def scoped_collection
      Staff.where(:school_id => current_admin_user.school_id).all
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

end
