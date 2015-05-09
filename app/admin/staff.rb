ActiveAdmin.register Staff do

permit_params permit_params :email, :school_id, :house_id

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
      f.input :school
      f.input :house
    end
    f.actions
  end


end
