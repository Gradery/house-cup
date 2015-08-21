ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :school_id

  index do
    selectable_column
    id_column
    column :email
    actions
  end

  filter :email
  filter :school, :collection => proc { School.all }, if: proc{ current_admin_user.school_id.nil?}

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :school, :collection => School.all if current_admin_user.school_id.nil?
    end
    f.actions
  end

  controller do
    def scoped_collection
      if !current_admin_user.school_id.nil?
        AdminUser.where(:school_id => current_admin_user.school_id).all
      else
        AdminUser.all
      end
    end

    def update
      if !current_admin_user.school_id.nil?
        params[:admin_user][:school_id] = current_admin_user.school_id
      end
      super
    end

    def create
      if !current_admin_user.school_id.nil?
        params[:admin_user][:school_id] = current_admin_user.school_id
      end
      super
    end
  end

end
