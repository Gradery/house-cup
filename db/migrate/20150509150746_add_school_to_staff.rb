class AddSchoolToStaff < ActiveRecord::Migration
  def change
    add_column :staffs, :school_id, :string
  end
end
