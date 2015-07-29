class AddDeletedAtToSchool < ActiveRecord::Migration
  def change
    add_column :schools, :deleted_at, :datetime
    add_index :schools, :deleted_at
  end
end
