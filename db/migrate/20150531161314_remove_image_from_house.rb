class RemoveImageFromHouse < ActiveRecord::Migration
  def change
    remove_column :houses, :image, :string
  end
end
