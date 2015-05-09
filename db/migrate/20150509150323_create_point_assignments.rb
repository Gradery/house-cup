class CreatePointAssignments < ActiveRecord::Migration
  def change
    create_table :point_assignments do |t|
      t.integer :staff_id
      t.integer :house_id
      t.integer :activity_id

      t.timestamps
    end
  end
end
