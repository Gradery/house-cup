class AddDeletedAtToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :deleted_at, :datetime
    add_index :settings, :deleted_at
  end
end
