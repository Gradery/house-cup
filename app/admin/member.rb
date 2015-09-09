ActiveAdmin.register Member do

permit_params :school_id, :house_id, :email, :name, :badge_id, :grade

index do
	column :house
	column :name
  column :grade
	column :badge_id
	column :email
  column (:school) {|activity| activity.school.name} if current_admin_user.school_id.nil?
  column (:behavior_report){|a|link_to "Behavior Report", "/admin/members/"+a.id.to_s+"/behavior_report"}
	actions
end

filter :house, :collection => proc{ House.where(:school_id => current_admin_user.school_id).all }, if: proc{ !current_admin_user.school_id.nil?}
filter :name
filter :grade
filter :email
filter :badge_id
filter :school, :collection => proc { School.all }, if: proc{ current_admin_user.school_id.nil?}

form do |f|
    f.inputs "Member" do
      f.input :house, :collection => House.where(:school_id => current_admin_user.school_id).all
      f.input :name
      f.input :grade, :collection => Setting.where(:school_id => 1, :key => "grades").first.value.split(",").delete_if{|a| a.downcase == "other"}
      f.input :email
      f.input :badge_id
      f.input :school, :collection => School.all if current_admin_user.school_id.nil?
    end
    f.actions
  end

member_action :behavior_report, method: :get do
  assignments = PointAssignment.where(:member => resource).all
  csv_string = CSV.generate do |csv|
    csv << ["'ID", "Activity", "Points", "Note", "Date / Time"]
    assignments.each do |a|
      if a.custom_points
        csv << [a.id.to_s, a.custom_points_title, a.custom_points_amount.to_s, a.note, a.created_at.strftime("%e/%-m/%y %l:%M %p")]
      else
        csv << [a.id.to_s, a.activity.name, a.activity.points.to_s, a.note, a.created_at.strftime("%e/%-m/%y %l:%M %p")]
      end
    end
  end
  headers['Content-Disposition'] = "attachment; filename=\"Behavior Report "+resource.name+".csv\""
  headers['Content-Type'] ||= 'text/csv'
  render text: csv_string
end

controller do
    def scoped_collection
      if !current_admin_user.school_id.nil?
        Member.where(:school_id => current_admin_user.school_id).all
      else
        Member.all
      end
    end

    def update
	    if !current_admin_user.school_id.nil?
        params[:member][:school_id] = current_admin_user.school_id
      end
	    super
	  end

	  def create
	    if !current_admin_user.school_id.nil?
        params[:member][:school_id] = current_admin_user.school_id
      end
	    super
	  end
  end

csv do
  column(:house) { |assignment| assignment.house.name}
  column :badge_id
  column :name
end

end
