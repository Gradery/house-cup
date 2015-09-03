class AddNoteAndMemberIdToPointAssignment < ActiveRecord::Migration
  def change
    add_column :point_assignments, :note, :text
    add_column :point_assignments, :member_id, :integer
  end
end
