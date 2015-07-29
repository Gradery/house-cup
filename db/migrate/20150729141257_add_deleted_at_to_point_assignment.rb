class AddDeletedAtToPointAssignment < ActiveRecord::Migration
  def change
    add_column :point_assignments, :deleted_at, :datetime
    add_index :point_assignments, :deleted_at
  end
end
