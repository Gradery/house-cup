class AddCustomFieldsToPointAssignment < ActiveRecord::Migration
  def change
    add_column :point_assignments, :custom_points, :boolean, :default => false
    add_column :point_assignments, :custom_points_title, :text
    add_column :point_assignments, :custom_points_amount, :integer
  end
end
