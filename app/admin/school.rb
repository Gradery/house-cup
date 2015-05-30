ActiveAdmin.register School do

permit_params :name, :about

index do
	column :name
	actions
end

form do |f|
    f.inputs "School" do
      f.input :name
      f.input :about, as: :html_editor
    end
    f.actions
  end

controller do
  def scoped_collection
    School.where(:id => current_admin_user.school_id).all
  end
end

end