class AddGradeToMembers < ActiveRecord::Migration
  def change
    add_column :members, :grade, :string
  end
end
