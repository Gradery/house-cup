class AddDeletedAtToHouse < ActiveRecord::Migration
  def change
    add_column :houses, :deleted_at, :datetime
    add_index :houses, :deleted_at
  end
end
