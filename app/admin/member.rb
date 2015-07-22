ActiveAdmin.register Member do

permit_params :school_id, :house_id, :email, :name, :badge_id

index do
	column :house
	column :name
	column :badge_id
	column :email
	actions
end

filter :house, :collection => proc{ House.where(:school_id => current_admin_user.school_id).all }
filter :name
filter :email
filter :badge_id

form do |f|
    f.inputs "Member" do
      f.input :house, :collection => House.where(:school_id => current_admin_user.school_id).all
      f.input :name
      f.input :email
      f.input :badge_id
    end
    f.actions
  end

controller do
    def scoped_collection
      Member.where(:school_id => current_admin_user.school_id).all
    end

    def update
	    params[:member][:school_id] = current_admin_user.school_id
	    super
	  end

	  def create
	    params[:member][:school_id] = current_admin_user.school_id
	    super
	  end
  end

csv do
  column(:house) { |assignment| assignment.house.name}
  column :badge_id
  column :name
end

end
