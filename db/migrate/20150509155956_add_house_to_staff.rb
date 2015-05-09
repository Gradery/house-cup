class AddHouseToStaff < ActiveRecord::Migration
  def change
    add_column :staffs, :house_id, :integer
  end
end
