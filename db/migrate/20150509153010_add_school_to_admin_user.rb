class AddSchoolToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :school_id, :integer
  end
end
