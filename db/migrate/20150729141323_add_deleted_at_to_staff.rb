class AddDeletedAtToStaff < ActiveRecord::Migration
  def change
    add_column :staffs, :deleted_at, :datetime
    add_index :staffs, :deleted_at
  end
end
