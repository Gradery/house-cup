ActiveAdmin.register Staff do

permit_params :email, :school_id, :house_id, :password, :password_confirmation, :grade

index do
    selectable_column
    column :name
    column :email
    column :house
    column :grade
    column (:school) {|activity| activity.school.name} if current_admin_user.school_id.nil?
    actions
  end

  filter :name
  filter :email
  filter :house, :collection => proc { House.where(:school_id => current_admin_user.school_id).all }
  filter :school, :collection => proc { School.all }, if: proc{ current_admin_user.school_id.nil?}

  
  form do |f|
    f.inputs "Staff Details" do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :house, :collection => House.where(:school_id => current_admin_user.school_id).all if !current_admin_user.school_id.nil?
      f.input :house, :collection => House.all if current_admin_user.school_id.nil?
      f.input :grade, :collection => Setting.where(:school_id => current_admin_user.school_id.to_i, :key => "grades").first.value.split(",") if !current_admin_user.school_id.nil?
      f.input :school, :collection => School.all if current_admin_user.school_id.nil?
    end
    f.actions
  end

  controller do
    def scoped_collection
      if !current_admin_user.school_id.nil?
        Staff.where(:school_id => current_admin_user.school_id.to_s).all
      else
        Staff.all
      end
    end
  end

  controller do
    def update
      # don't try to update the password to blank if the password is blank.
      if params[:staff][:password].blank? && params[:staff][:password_confirmation].blank?
        params[:staff].delete("password")
        params[:staff].delete("password_confirmation")
      end
      # set the staff school to the admin user's school if they are not a super admin.
      if !current_admin_user.school_id.nil?
        params[:staff][:school_id] = current_admin_user.school_id
      end
      super
    end
  end

  csv do
    column :email
    column (:house) {|staff| staff.house.name}
  end

end
