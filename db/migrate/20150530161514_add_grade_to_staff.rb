class AddGradeToStaff < ActiveRecord::Migration
  def change
    add_column :staffs, :grade, :string
  end
end
