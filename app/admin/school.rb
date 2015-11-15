ActiveAdmin.register School do

  permit_params :name, :url, :about

  index do
    selectable_column
  	column :name
  	actions
  end

  form do |f|
    f.inputs "School" do
      f.input :name
      f.input :url if current_admin_user.school_id.nil?
      f.input :about, as: :html_editor
    end
    f.actions
  end

  controller do
    def scoped_collection
      if !current_admin_user.school_id.nil?
        School.where(:id => current_admin_user.school_id).all
      else
        School.all
      end
    end

    # def permitted_params
    #   params.permit :utf8, :_wysihtml5_mode, :authenticity_token, :commit,
    #       school: [:name, :about, :url]
    # end
  end

end