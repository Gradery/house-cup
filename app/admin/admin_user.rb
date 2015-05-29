ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    actions
  end

  filter :email

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    def scoped_collection
      AdminUser.where(:school_id => current_admin_user.school_id).all
    end

    def update
      params[:admin_user][:school_id] = current_admin_user.school_id
      super
    end

    def create
      params[:admin_user][:school_id] = current_admin_user.school_id
      super
    end
  end

end
